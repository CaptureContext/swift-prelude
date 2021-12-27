extension Bool {
  public func or(_ value: @autoclosure () -> Bool) -> Bool {
    return self || value()
  }
}

public func or(_ a: Bool, _ b: @autoclosure () -> Bool) -> Bool {
  return a || b()
}

public func or(
  _ a: Bool,
  _ b: @autoclosure () -> Bool,
  _ c: @autoclosure () -> Bool
) -> Bool {
  return a || b() || c()
}

public func or(
  _ a: Bool,
  _ b: @autoclosure () -> Bool,
  _ c: @autoclosure () -> Bool,
  _ d: @autoclosure () -> Bool
) -> Bool {
  return a || b() || c() || d()
}

public func or(
  _ a: Bool,
  _ b: @autoclosure () -> Bool,
  _ c: @autoclosure () -> Bool,
  _ d: @autoclosure () -> Bool,
  _ e: @autoclosure () -> Bool
) -> Bool {
  return a || b() || c() || d() || e()
}

public func or(
  _ a: Bool,
  _ b: @autoclosure () -> Bool,
  _ c: @autoclosure () -> Bool,
  _ d: @autoclosure () -> Bool,
  _ e: @autoclosure () -> Bool,
  _ f: @autoclosure () -> Bool
) -> Bool {
  return a || b() || c() || d() || e() || f()
}

public func or(
  _ a: Bool,
  _ b: @autoclosure () -> Bool,
  _ c: @autoclosure () -> Bool,
  _ d: @autoclosure () -> Bool,
  _ e: @autoclosure () -> Bool,
  _ f: @autoclosure () -> Bool,
  _ g: @autoclosure () -> Bool
) -> Bool {
  return a || b() || c() || d() || e() || f() || g()
}

/// Logical `or` for prepared values
///
/// Does not use `@autoclosure` to compute result
public func computedOr(
  _ a: Bool,
  _ b: Bool
) -> Bool {
  return or(a, b)
}

/// Logical `or` for prepared values
///
/// Does not use `@autoclosure` to compute result
public func computedOr(
  _ a: Bool,
  _ b: Bool,
  _ c: Bool
) -> Bool {
  return or(a, b, c)
}

/// Logical `or` for prepared values
///
/// Does not use `@autoclosure` to compute result
public func computedOr(
  _ a: Bool,
  _ b: Bool,
  _ c: Bool,
  _ d: Bool
) -> Bool {
  return or(a, b, c, d)
}

/// Logical `or` for prepared values
///
/// Does not use `@autoclosure` to compute result
public func computedOr(
  _ a: Bool,
  _ b: Bool,
  _ c: Bool,
  _ d: Bool,
  _ e: Bool
) -> Bool {
  return or(a, b, c, d, e)
}

/// Logical `or` for prepared values
///
/// Does not use `@autoclosure` to compute result
public func computedOr(
  _ a: Bool,
  _ b: Bool,
  _ c: Bool,
  _ d: Bool,
  _ e: Bool,
  _ f: Bool
) -> Bool {
  return or(a, b, c, d, e, f)
}

/// Logical `or` for prepared values
///
/// Does not use `@autoclosure` to compute result
public func computedOr(
  _ a: Bool,
  _ b: Bool,
  _ c: Bool,
  _ d: Bool,
  _ e: Bool,
  _ f: Bool,
  _ g: Bool
) -> Bool {
  return or(a, b, c, d, e, f, g)
}
