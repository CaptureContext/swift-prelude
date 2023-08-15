extension Bool {
  @inlinable
  public static func ^ (rhs: Bool, lhs: Bool) -> Bool {
    return rhs != lhs
  }

  @inlinable
  public func xor(_ value: Bool) -> Bool {
    self ^ value
  }
}
