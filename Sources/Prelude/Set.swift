extension Set: Semigroup {
  @inlinable
  public static func <>(lhs: Set, rhs: Set) -> Set {
    return lhs.union(rhs)
  }
}
