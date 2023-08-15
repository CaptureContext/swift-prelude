public struct Endo<A>: SyncFunction {
  public let syncCall: (A) -> A

  public init(syncCall: @escaping (A) -> A) {
    self.syncCall = syncCall
  }
}

extension Endo: Semigroup {
  @inlinable
  public static func <> (lhs: Endo<A>, rhs: Endo<A>) -> Endo<A> {
    return .sync(lhs.syncCall >>> rhs.syncCall)
  }
}

extension Endo: Monoid {
  @inlinable
  public static var empty: Endo<A> {
    return .sync(id)
  }
}

extension Endo {
  @inlinable
  public func imap<B>(
    _ f: @escaping (A) -> B,
    _ g: @escaping (B) -> A
  ) -> Endo<B> {
    return .sync(f <<< self.syncCall <<< g)
  }
}
