public typealias EndoFunctionOf<T> = Function<T, T>

public typealias FunctionOf<F: FunctionSignatureProtocol> = Function<
  F.Input,
  F.Output
>

public protocol Function<Input, Output>: FunctionSignatureProtocol {
  typealias SyncSignature = SyncFunctionSignature<Input, Output>
  typealias AsyncSignature = AsyncFunctionSignature<Input, Output>

  init(_ call: @escaping SyncSignature)
  func callAsFunction(_ input: Input) async -> Output
}

// MARK: Calls

extension Function where Input == Void {
  @inlinable
  public func callAsFunction() async -> Output {
    return await callAsFunction(())
  }
}

extension Function where Input == Unit {
  @inlinable
  public func callAsFunction() async -> Output {
    return await callAsFunction(Prelude.unit)
  }
}

extension Function {
  @inlinable
  @discardableResult
  public func callAsFunction(
    _ input: Input,
    priority: TaskPriority? = .none,
    completion: @escaping (Output) -> Void
  ) -> Task<Void, Never> {
    return .lazy(priority: priority, callAsFunction)(input)(completion)
  }
}

// MARK: Type erasure

extension Function {
  @inlinable
  public func eraseToFunction() -> some Function<Input, Output> { self }
}

// MARK: Static factory

extension Function where Input == Never {
  @inlinable
  public static var absurd: Self {
    return .init(Prelude.absurd)
  }
}

extension Function where Output == Void {
  @inlinable
  public static var void: Self {
    return .init { _ in }
  }
}

extension Function where Output == Unit {
  @inlinable
  public static var unit: Self {
    return .init { _ in Prelude.unit }
  }
}

extension Function {
  @inlinable
  public static func pure(
    _ output: Output
  ) -> Self {
    return .const(output)
  }

  @inlinable
  public static func const(
    _ value: Output
  ) -> Self {
    return .init(Prelude.const(value))
  }

  @inlinable
  public static func unimplemented(
    file: StaticString = #fileID,
    line: UInt = #line
  ) -> Self {
    return .init { _ in
      fatalError(
        "Call to unimplemented SyncFunction declared on \(file):\(line)."
      )
    }
  }
}

// MARK: Default methods
// Default methods are declared for async

// MARK: Applicative

extension Function {
  @inlinable
  public func apply<
    F: Function,
    G: Function,
    NewOutput
  >(
    _ f: F
  ) -> some AsyncFunction<Input, NewOutput> where
    F.Input == Input,
    F.Output == G,
    G.Input == Output,
    G.Output == NewOutput
  {
    return AsyncFunc { a in await f(a)(callAsFunction(a)) }
  }

  @inlinable
  public static func <*> <
    F: Function,
    G: Function,
    NewOutput
  >(
    lhs: F,
    rhs: Self
  ) -> some AsyncFunction<Input, NewOutput> where
    F.Input == Input,
    F.Output == G,
    G.Input == Output,
    G.Output == NewOutput
  {
    return rhs.apply(lhs)
  }
}

// MARK: Functor

extension Function {
  @inlinable
  public func map<NewOutput>(
    _ f: @escaping (Output) async -> NewOutput
  ) -> some AsyncFunction<Input, NewOutput> {
    return AsyncFunc(f <<< callAsFunction)
  }

  @inlinable
  public static func <¢> <NewOutput>(
    lhs: @escaping (Output) async -> NewOutput,
    rhs: Self
  ) -> some AsyncFunction<Input, NewOutput> {
    return rhs.map(lhs)
  }
}

// MARK: Contravariant & Profunctor & Monad

extension Function {
  @inlinable
  public func contramap<NewInput>(
    _ f: @escaping (NewInput) async -> Input
  ) -> some AsyncFunction<NewInput, Output> {
    return AsyncFunc(f >>> callAsFunction)
  }
}

extension Function {
  @inlinable
  public func dimap<
    NewInput,
    NewOutput
  >(
    _ fi: @escaping (NewInput) async -> Input,
    _ fo: @escaping (Output) async -> NewOutput
  ) -> some AsyncFunction<NewInput, NewOutput> {
    return contramap(fi).map(fo)
  }
}

extension Function {
  @inlinable
  public func flatMap<F: Function>(
    _ f: @escaping (Output) async -> F
  ) -> some AsyncFunctionOf<F> where
    F.Input == Input
  {
    return AsyncFunc { await f(callAsFunction($0))($0) }
  }
}

// MARK: Semigroupoid

extension Function {
  @inlinable
  public static func >>> <G: Function>(
    lhs: Self,
    rhs: G
  ) -> some AsyncFunction<Input, G.Output> where
    G.Input == Output
  {
    return AsyncFunc(lhs.callAsFunction >>> rhs.callAsFunction)
  }

  @inlinable
  public static func <<< <F: Function>(
    lhs: F,
    rhs: Self
  ) -> some AsyncFunction<Input, F.Output> where
    F.Input == Output
  {
    return AsyncFunc(lhs.callAsFunction <<< rhs.callAsFunction)
  }
}

// MARK: Endo

extension Function where Input == Output {
  @inlinable
  public func imap<T>(
    _ f: @escaping (Output) async -> T,
    _ g: @escaping (T) async -> Input
  ) -> some AsyncFunction<T, T> {
    return AsyncFunc(f <<< callAsFunction <<< g)
  }

  @inlinable
  public static func <> <
    F: FunctionOf<Self>
  >(
    lhs: Self,
    rhs: F
  ) -> some AsyncFunctionOf<Self> {
    return lhs >>> rhs
  }

  @inlinable
  public static var empty: some AsyncFunctionOf<Self> {
    return AsyncFunc(Prelude.id)
  }
}
