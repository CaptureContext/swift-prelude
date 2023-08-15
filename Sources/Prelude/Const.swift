@inlinable
public func const<A>(_ a: A) -> () -> A {
  return { a }
}

@inlinable
public func const<A, B>(_ a: A) -> (B) -> A {
  return { _ in a }
}
