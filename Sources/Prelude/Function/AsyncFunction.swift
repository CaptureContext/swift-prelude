public protocol AsyncFunction {
  associatedtype Input
  associatedtype AsyncOutput
  typealias SyncOutput = AsyncFunctionSyncHandler<AsyncOutput>
  typealias SyncSignature = AsyncFunctionSyncSignature<Input, AsyncOutput>
  typealias AsyncSignature = AsyncFunctionSignature<Input, AsyncOutput>
  var asyncCall: AsyncSignature { get }
  init(asyncCall: @escaping AsyncSignature)
}

public typealias FunctionSignature<A, B> = (A) -> B
public typealias AsyncFunctionSignature<A, B> = (A) async -> B
public typealias AsyncFunctionSyncHandler<A> = (@escaping (A) -> Void) -> Void
public typealias AsyncFunctionSyncSignature<A, B> = FunctionSignature<A, AsyncFunctionSyncHandler<B>>

extension AsyncFunction where Input == Void {
  public func callAsFunction() async -> AsyncOutput { return await asyncCall(()) }
}

extension AsyncFunction {
  @inlinable
  public static func async(_ asyncCall: @escaping AsyncSignature) -> Self {
    return .init(asyncCall: asyncCall)
  }

  public init(_ asyncCall: @escaping AsyncSignature) {
    self.init(asyncCall: asyncCall)
  }

  @inlinable
  public static func sync(_ syncCall: @escaping SyncSignature) -> Self {
    return .async { input in
      await withCheckedContinuation { continuation in
        syncCall(input)(continuation.resume)
      }
    }
  }

  @inlinable
  public static func uncheckedSync(_ syncCall: @escaping SyncSignature) -> Self {
    return .async { input in
      await withUnsafeContinuation { continuation in
        syncCall(input)(continuation.resume)
      }
    }
  }
  
  public var syncCall: SyncSignature {
    return Task.lazy(asyncCall)
  }
}

extension AsyncFunction where Input == Never {
  public static var absurd: Self {
    return .async(Prelude.absurd)
  }
}

extension AsyncFunction {
  @inlinable
  public static func const(_ value: AsyncOutput) -> Self {
    return .async(Prelude.const(value))
  }

  @inlinable
  public static func unimplemented(
    file: StaticString = #fileID,
    line: UInt = #line
  ) -> Self {
    return .async { _ in
      fatalError(
        "Call to unimplemented function declared on \(file):\(line)."
      )
    }
  }
}

extension AsyncFunction {
  public func eraseToSyncFunc() -> SyncFunc<Input, SyncOutput> {
    return .sync(syncCall)
  }

  public func eraseToAsyncFunc() -> AsyncFunc<Input, AsyncOutput> {
    return .async(asyncCall)
  }
}

extension AsyncFunction {
  public func callAsFunction(_ input: Input) async -> AsyncOutput {
    return await asyncCall(input)
  }
}

extension AsyncFunction /* : Semigroupoid */ {
  @inlinable
  public static func >>> <G: AsyncFunction>(
    f: Self,
    g: G
  ) -> AsyncFunc<Input, G.AsyncOutput>
  where G.Input == AsyncOutput {
    return .async(f.asyncCall >>> g.asyncCall)
  }

  @inlinable
  public static func <<< <F: AsyncFunction>(
    f: F,
    g: Self
  ) -> AsyncFunc<Input, F.AsyncOutput>
  where F.Input == AsyncOutput {
    return .async(f.asyncCall <<< g.asyncCall)
  }
}

extension AsyncFunction /* : Functor */ {
  public func map<C>(
    _ f: @escaping (AsyncOutput) async -> C
  ) -> AsyncFunc<Input, C> {
    return .async(self.asyncCall >>> f)
  }

  @inlinable
  public static func <¢> <C>(
    f: @escaping (AsyncOutput) -> C,
    g: Self
  ) -> AsyncFunc<Input, C> {
    return g.map(f)
  }
}

@inlinable
public func map<A, B, C, F: AsyncFunction>(
  _ f: @escaping (B) async -> C
) -> (F) -> AsyncFunc<A, C>
where F.Input == A, F.AsyncOutput == B {
  return { $0.map(f) }
}

extension AsyncFunction {
  public func contramap<Z>(
    _ f: @escaping (Z) async -> Input
  ) -> AsyncFunc<Z, AsyncOutput> {
    return .async(f >>> self.asyncCall)
  }
}

@inlinable
public func contramap<A, B, C, G: AsyncFunction>(
  _ f: @escaping (B) -> A
) -> (G) -> AsyncFunc<B, C>
where G.Input == A, G.AsyncOutput == C {
  return { $0.contramap(f) }
}

extension AsyncFunction /* : Profunctor */ {
  public func dimap<Z, C>(
    _ f: @escaping (Z) async -> Input,
    _ g: @escaping (AsyncOutput) -> C
  ) -> AsyncFunc<Z, C> {
    return .async(f >>> self.asyncCall >>> g)
  }
}

extension AsyncFunction /* : Apply */ {
  public func apply<F: AsyncFunction, G: AsyncFunction, C>(
    _ f: F
  ) -> AsyncFunc<Input, C>
  where F.Input == Input, F.AsyncOutput == G, G.Input == AsyncOutput, G.AsyncOutput == C {
    return .async { a in await f.asyncCall(a).asyncCall(self.asyncCall(a)) }
  }

  @inlinable
  public static func <*> <F: AsyncFunction, G: AsyncFunction, C>(
    f: F,
    x: Self
  ) -> AsyncFunc<Input, C>
  where F.Input == Input, F.AsyncOutput == G, G.Input == AsyncOutput, G.AsyncOutput == C {
    return x.apply(f)
  }
}

@inlinable
public func apply<F: AsyncFunction, G: AsyncFunction, B, C>(
  _ f: F
) -> (AsyncFunc<F.Input, B>) -> AsyncFunc<F.Input, C>
where F.AsyncOutput == G, G.Input == B, G.AsyncOutput == C {
  return { $0.apply(f) }
}

// MARK: Applicative
extension AsyncFunction {
  @inlinable
  public static func pure(_ b: AsyncOutput) -> Self {
    return .const(b)
  }
}

extension AsyncFunction /* : Monad */ {
  public func flatMap<F: AsyncFunction>(
    _ f: @escaping (AsyncOutput) async -> F
  ) -> AsyncFunc<Input, F.AsyncOutput>
  where F.Input == Input {
    return .async { await f(self.asyncCall($0)).asyncCall($0) }
  }
}

@inlinable
public func flatMap<F: AsyncFunction, C>(
  _ f: @escaping (C) -> F
) -> (AsyncFunc<F.Input, C>) -> AsyncFunc<F.Input, F.AsyncOutput> {
  return { $0.flatMap(f) }
}

extension AsyncFunction where AsyncOutput: Semigroup {
  @inlinable
  public static func <> (f: Self, g: Self) -> Self {
    return .async { await f.asyncCall($0) <> g.asyncCall($0) }
  }
}

extension AsyncFunction where AsyncOutput: Monoid {
  public static var empty: Self {
    return .const(.empty)
  }
}

extension AsyncFunction where AsyncOutput: NearSemiring {
  @inlinable
  public static func + (f: Self, g: Self) -> Self {
    return .async { await f.asyncCall($0) + g.asyncCall($0) }
  }

  @inlinable
  public static func * (f: Self, g: Self) -> Self {
    return .async { await f.asyncCall($0) * g.asyncCall($0) }
  }

  public static var zero: Self {
    return .const(.zero)
  }
}

extension AsyncFunction where AsyncOutput: Semiring {
  public static var one: Self {
    return .const(.one)
  }
}

extension Task where Success == Void, Failure == Never {
  @inlinable
  public static func `lazy`<Input, Output>(
    priority: TaskPriority? = .none,
    _ asyncCall: @escaping (Input) async -> Output
  ) -> (Input) -> (@escaping (Output) -> Void) -> Task {
    return { input in
      return { handler in
        Task(priority: priority) { await handler(asyncCall(input)) }
      }
    }
  }

  @inlinable
  public static func `lazy`<Input, Output>(
    priority: TaskPriority? = .none,
    _ asyncCall: @escaping (Input) async -> Output
  ) -> AsyncFunctionSyncSignature<Input, Output> {
    return { input in
      return { handler in
        Task(priority: priority) { await handler(asyncCall(input)) }
      }
    }
  }
}

@discardableResult
@inlinable
public func discard<T>(_ value: T) -> T { value }
