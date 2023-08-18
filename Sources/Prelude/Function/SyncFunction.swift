public typealias SyncFunctionEndoOf<T> = SyncFunction<T, T>

public typealias SyncFunctionOf<F: FunctionSignatureProtocol> = SyncFunction<
  F.Input,
  F.Output
>

public protocol SyncFunction<Input, Output>: Function {
  func callAsFunction(_ input: Input) -> Output
}

// MARK: Type erasure

extension SyncFunction {
  @inlinable
  public func eraseToSyncFunction() -> some SyncFunction<Input, Output> { self }
}

// MARK: Calls

extension SyncFunction where Input == Void {
  @inlinable
  public func callAsFunction() -> Output {
    return callAsFunction(())
  }
}

extension SyncFunction where Input == Unit {
  @inlinable
  public func callAsFunction() -> Output {
    return callAsFunction(Prelude.unit)
  }
}

// MARK: Async

extension SyncFunction {
  @inlinable
  public func callAsFunction(_ input: Input) async -> Output {
    return _call(input)
  }

  @usableFromInline
  internal func _call(_ input: Input) -> Output {
    callAsFunction(input)
  }
}

// MARK: Applicative

extension SyncFunction {
  @inlinable
  public func apply<
    F: SyncFunction,
    G: SyncFunction,
    NewOutput
  >(
    _ f: F
  ) -> some SyncFunction<Input, NewOutput> where
    F.Input == Input,
    F.Output == G,
    G.Input == Output,
    G.Output == NewOutput
  {
    return SyncFunc { a in f(a)(callAsFunction(a)) }
  }

  @inlinable
  public static func <*> <
    F: SyncFunction,
    G: SyncFunction,
    NewOutput
  >(
    lhs: F,
    rhs: Self
  ) -> some SyncFunction<Input, NewOutput> where
    F.Input == Input,
    F.Output == G,
    G.Input == Output,
    G.Output == NewOutput
  {
    return rhs.apply(lhs)
  }
}

// MARK: Functor

extension SyncFunction {
  @inlinable
  public func map<NewOutput>(
    _ f: @escaping (Output) -> NewOutput
  ) -> some SyncFunction<Input, NewOutput> {
    return SyncFunc(f <<< callAsFunction)
  }

  @inlinable
  public static func <¢> <NewOutput>(
    lhs: @escaping (Output) -> NewOutput,
    rhs: Self
  ) -> some SyncFunction<Input, NewOutput> {
    return rhs.map(lhs)
  }
}

// MARK: Contravariant & Profunctor & Monad

extension SyncFunction {
  @inlinable
  public func contramap<NewInput>(
    _ f: @escaping (NewInput) -> Input
  ) -> some SyncFunction<NewInput, Output> {
    return SyncFunc(f >>> callAsFunction)
  }
}

extension SyncFunction {
  @inlinable
  public func dimap<
    NewInput,
    NewOutput
  >(
    _ fi: @escaping (NewInput) -> Input,
    _ fo: @escaping (Output) -> NewOutput
  ) -> some SyncFunction<NewInput, NewOutput> {
    return contramap(fi).map(fo)
  }
}

extension SyncFunction {
  @inlinable
  public func flatMap<F: SyncFunction>(
    _ f: @escaping (Output) -> F
  ) -> some SyncFunctionOf<F> where
    F.Input == Input
  {
    return SyncFunc { f(callAsFunction($0))($0) }
  }
}

// MARK: Semigroupoid

extension SyncFunction {
  @inlinable
  public static func >>> <G: SyncFunction>(
    lhs: Self,
    rhs: G
  ) -> some SyncFunction<Input, G.Output> where
    G.Input == Output
  {
    return SyncFunc(lhs.callAsFunction >>> rhs.callAsFunction)
  }

  @inlinable
  public static func <<< <F: SyncFunction>(
    lhs: F,
    rhs: Self
  ) -> some SyncFunction<Input, F.Output> where
    F.Input == Output
  {
    return SyncFunc(lhs.callAsFunction <<< rhs.callAsFunction)
  }
}

// MARK: Endo

extension SyncFunction where Input == Output {
  @inlinable
  public func imap<T>(
    _ f: @escaping (Output) -> T,
    _ g: @escaping (T) -> Input
  ) -> some SyncFunction<T, T> {
    return SyncFunc(f <<< callAsFunction <<< g)
  }

  @inlinable
  public static func <> <
    F: SyncFunctionOf<Self>
  >(
    lhs: Self,
    rhs: F
  ) -> some SyncFunctionOf<Self> {
    return lhs >>> rhs
  }

  @inlinable
  public static var empty: some SyncFunctionOf<Self> {
    return SyncFunc(Prelude.id)
  }
}
