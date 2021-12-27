import Foundation

public func equal<T: Equatable>(
  _ a: T,
  _ b: T
) -> Bool {
  return equal(a, b, by: ==)
}

public func equal<T>(
  _ a: T,
  _ b: T,
  by comparator: (T, T) -> Bool
) -> Bool {
  return comparator(a, b)
}

public func equal<T, U: Equatable>(
  _ a: T,
  _ b: T,
  by prop: (T) -> U
) -> Bool {
  return equal(prop(a), prop(b))
}
