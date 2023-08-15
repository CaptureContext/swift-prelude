public struct SyncFunc<Input, Output>: SyncFunction {
  public let syncCall: (Input) -> Output

  public init(syncCall: @escaping (Input) -> Output) {
    self.syncCall = syncCall
  }
}

// Have to implement in on a Func type directly due to compilation error:
// - Member operator '>¢<' of protocol 'Function' must have at least one argument of type 'Self'
extension SyncFunc { // Contravariant
  @inlinable
  public static func >¢< <A, B, C>(
    f: @escaping (B) -> A, g: SyncFunc<A, C>
  ) -> SyncFunc<B, C> {
    return g.contramap(f)
  }
}

@inlinable
public func dimap<A, B, C, D>(
  _ f: @escaping (A) -> B,
  _ g: @escaping (C) -> D
) -> (SyncFunc<B, C>) -> SyncFunc<A, D> {
  return { $0.dimap(f, g) }
}

// MARK: Applicative

@inlinable
public func pure<A, B>(_ b: B) -> SyncFunc<A, B> {
  return .init(const(b))
}

extension SyncFunc: Semigroup where SyncOutput: Semigroup {}
  
extension SyncFunc: Monoid where SyncOutput: Monoid {}

extension SyncFunc: NearSemiring where SyncOutput: NearSemiring {}

extension SyncFunc: Semiring where SyncOutput: Semiring {}
