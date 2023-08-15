public protocol SyncFunction {
  associatedtype Input
  associatedtype SyncOutput
  typealias A = Input
  typealias B = SyncOutput
  typealias SyncSignature = (Input) -> SyncOutput
  var syncCall: SyncSignature { get }
  init(syncCall: @escaping SyncSignature)
}

extension SyncFunction where Input == Never {
  @inlinable
  public static var absurd: Self {
    return .init(Prelude.absurd)
  }
}

extension SyncFunction {
  @inlinable
  public init(_ syncCall: @escaping SyncSignature) {
    self.init(syncCall: syncCall)
  }

  @inlinable
  public static func sync(_ syncCall: @escaping SyncSignature) -> Self {
    return .init(syncCall)
  }

  @inlinable
  public static func const(_ value: SyncOutput) -> Self {
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

extension SyncFunction {
  @inlinable
  public func eraseToFunc() -> SyncFunc<Input, SyncOutput> {
    return .sync(syncCall)
  }

  @inlinable
  public func eraseToAsyncFunc() -> AsyncFunc<Input, SyncOutput> {
    return .async(syncCall)
  }
}

extension SyncFunction {
  @inlinable
  public func callAsFunction(_ Input: Input) -> SyncOutput {
    return syncCall(Input)
  }
}

extension SyncFunction where Input == Void {
  @inlinable
  public func callAsFunction() -> SyncOutput {
    return syncCall(())
  }
}

extension SyncFunction /* : Semigroupoid */ {
  @inlinable
  public static func >>> <G: SyncFunction>(
    f: Self,
    g: G
  ) -> SyncFunc<A, G.SyncOutput>
  where G.Input == B {
    return .sync(f.syncCall >>> g.syncCall)
  }

  @inlinable
  public static func <<< <F: SyncFunction>(f: F, g: Self) -> SyncFunc<A, F.SyncOutput> where F.Input == B {
    return .sync(f.syncCall <<< g.syncCall)
  }
}

extension SyncFunction /* : Functor */ {
  @inlinable
  public func map<C>(_ f: @escaping (B) -> C) -> SyncFunc<A, C> {
    return .sync(self.syncCall >>> f)
  }

  @inlinable
  public static func <¢> <C>(f: @escaping (B) -> C, g: Self) -> SyncFunc<A, C> {
    return g.map(f)
  }
}

@inlinable
public func map<A, B, C, F: SyncFunction>(_ f: @escaping (B) -> C) -> (F) -> SyncFunc<A, C>
where F.Input == A, F.SyncOutput == B {
  return { $0.map(f) }
}

extension SyncFunction {
  @inlinable
  public func contramap<Z>(_ f: @escaping (Z) -> A) -> SyncFunc<Z, B> {
    return .sync(f >>> self.syncCall)
  }
}

@inlinable
public func contramap<A, B, C, G: SyncFunction>(_ f: @escaping (B) -> A) -> (G) -> SyncFunc<B, C>
where G.Input == A, G.SyncOutput == C {
  return { $0.contramap(f) }
}

extension SyncFunction /* : Profunctor */ {
  @inlinable
  public func dimap<Z, C>(_ f: @escaping (Z) -> A, _ g: @escaping (B) -> C) -> SyncFunc<Z, C> {
    return .sync(f >>> self.syncCall >>> g)
  }
}

extension SyncFunction /* : Apply */ {
  @inlinable
  public func apply<F: SyncFunction, G: SyncFunction, C>(_ f: F) -> SyncFunc<A, C>
  where F.Input == A, F.SyncOutput == G, G.Input == B, G.SyncOutput == C {
    return .init { a in f.syncCall(a).syncCall(self.syncCall(a)) }
  }

  @inlinable
  public static func <*> <F: SyncFunction, G: SyncFunction, C>(f: F, x: Self) -> SyncFunc<A, C>
  where F.Input == A, F.SyncOutput == G, G.Input == B, G.SyncOutput == C {
    return x.apply(f)
  }
}

@inlinable
public func apply<
  F: SyncFunction,
  G: SyncFunction,
  B,
  C
> (
  _ f: F
) -> (SyncFunc<F.Input, B>) -> SyncFunc<F.Input, C>
where F.SyncOutput == G, G.Input == B, G.SyncOutput == C {
  return { $0.apply(f) }
}

// MARK: Applicative
extension SyncFunction {
  @inlinable
  public static func pure(_ b: B) -> Self {
    return .const(b)
  }
}

extension SyncFunction { // Monad
  @inlinable
  public func flatMap<F: SyncFunction>(_ f: @escaping (B) -> F) -> SyncFunc<A, F.SyncOutput>
  where F.Input == A {
    return .init { f(self.syncCall($0)).syncCall($0) }
  }
}

@inlinable
public func flatMap<F: SyncFunction, C>(_ f: @escaping (C) -> F) -> (SyncFunc<F.Input, C>) -> SyncFunc<F.Input, F.SyncOutput> {
  return { $0.flatMap(f) }
}

extension SyncFunction where B: Semigroup {
  @inlinable
  public static func <> (f: Self, g: Self) -> Self {
    return .sync { f.syncCall($0) <> g.syncCall($0) }
  }
}

extension SyncFunction where B: Monoid {
  @inlinable
  public static var empty: Self {
    return .const(B.empty)
  }
}

extension SyncFunction where B: NearSemiring {
  @inlinable
  public static func + (f: Self, g: Self) -> Self {
    return .sync { f.syncCall($0) + g.syncCall($0) }
  }

  @inlinable
  public static func * (f: Self, g: Self) -> Self {
    return .sync { f.syncCall($0) * g.syncCall($0) }
  }

  @inlinable
  public static var zero: Self {
    return .const(B.zero)
  }
}

extension SyncFunction where B: Semiring {
  @inlinable
  public static var one: Self {
    return .const(B.one)
  }
}
