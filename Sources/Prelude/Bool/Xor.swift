extension Bool {
  public static func ^ (rhs: Bool, lhs: Bool) -> Bool {
    return rhs != lhs
  }
  
  public func xor(_ value: Bool) -> Bool {
    self ^ value
  }
}
