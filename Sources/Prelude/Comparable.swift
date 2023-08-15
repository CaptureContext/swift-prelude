extension Comparable {
  public static func compare(_ x: Self, _ y: Self) -> Comparator {
    if x == y {
      return .eq
    } else if x < y {
      return .lt
    } else { // x > y
      return .gt
    }
  }
}

@inlinable
public func compare<A: Comparable>(
  _ a: A
) -> (A) -> Comparator {
  return curry(A.compare) <| a
}

extension Bool: Comparable {
  @inlinable
  public static func < (lhs: Bool, rhs: Bool) -> Bool {
    return (lhs, rhs) == (false, true)
  }
}

extension Unit: Comparable {
  @inlinable
  public static func < (_: Unit, _: Unit) -> Bool {
    return false
  }
}

@inlinable
public func lessThan<A: Comparable>(
  _ a: A
) -> (A) -> Bool {
  return flip(curry(<)) <| a
}

@inlinable
public func lessThanOrEqual<A: Comparable>(
  to a: A
) -> (A) -> Bool {
  return flip(curry(<=)) <| a
}

@inlinable
public func greaterThan<A: Comparable>(
  _ a: A
) -> (A) -> Bool {
  return flip(curry(>)) <| a
}

@inlinable
public func greaterThanOrEqual<A: Comparable>(
  to a: A
) -> (A) -> Bool {
  return flip(curry(>=)) <| a
}

@inlinable
public func < <A, B: Comparable>(
  f: @escaping (A) -> B,
  x: B
) -> (A) -> Bool {
  return f >>> lessThan(x)
}

@inlinable
public func <= <A, B: Comparable>(
  f: @escaping (A) -> B,
  x: B
) -> (A) -> Bool {
  return f >>> lessThanOrEqual(to: x)
}

@inlinable
public func > <A, B: Comparable>(
  f: @escaping (A) -> B,
  x: B
) -> (A) -> Bool {
  return f >>> greaterThan(x)
}

@inlinable
public func >= <A, B: Comparable>(
  f: @escaping (A) -> B,
  x: B
) -> (A) -> Bool {
  return f >>> greaterThanOrEqual(to: x)
}

@inlinable
public func clamp<T>(
  _ to: CountableClosedRange<T>
) -> (T) -> T {
  return { element in
    min(to.upperBound, max(to.lowerBound, element))
  }
}

@inlinable
public func clamp<T>(
  _ to: CountableRange<T>
) -> (T) -> T {
  return { element in
    min(to.upperBound.advanced(by: -1), max(to.lowerBound, element))
  }
}

@available(*, deprecated, message: "Use `clamp` on a countable range instead")
@inlinable
public func clamp<T>(
  _ to: Range<T>
) -> (T) -> T {
  return { element in
    min(to.upperBound, max(to.lowerBound, element))
  }
}

@inlinable
public func their<A, B>(
  _ f: @escaping (A) -> B,
  _ g: @escaping (B, B) -> Bool
) -> (A, A) -> Bool {
  return { g(f($0), f($1)) }
}

@inlinable
public func their<A, B: Comparable>(
  _ f: @escaping (A) -> B
) -> (A, A) -> Bool {
  return their(f, <)
}
