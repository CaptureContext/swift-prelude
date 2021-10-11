public func id<A>(_ a: A) -> A {
  return a
}

public func <<< <A, B, C>(
  _ b2c: @escaping (B) -> C,
  _ a2b: @escaping (A) -> B
) -> (A) -> C {
  return { a in b2c(a2b(a)) }
}

public func >>> <A, B, C>(
  _ a2b: @escaping (A) -> B,
  _ b2c: @escaping (B) -> C
) -> (A) -> C {
  return { a in b2c(a2b(a)) }
}

public func const<A>(
  _ a: A
) -> () -> A {
  return { a }
}

public func const<A, B>(
  _ a: A
) -> (B) -> A {
  return { _ in a }
}

public func <| <A, B> (
  f: (A) -> B,
  a: A
) -> B {
  return f(a)
}

public func |> <A, B> (
  a: A,
  f: (A) -> B
) -> B {
  return f(a)
}

public func flip<A, B, C>(
  _ f: @escaping (A) -> (B) -> C
) -> (B) -> (A) -> C {
  return { b in
    { a in
      f(a)(b)
    }
  }
}

// MARK: - Bind/Monad

public func flatMap <A, B, C>(
  _ lhs: @escaping (B) -> ((A) -> C),
  _ rhs: @escaping (A) -> B
) -> (A) -> C {
  return { a in
    lhs(rhs(a))(a)
  }
}

public func >=> <A, B, C, D>(
  lhs: @escaping (A) -> ((D) -> B),
  rhs: @escaping (B) -> ((D) -> C)
) -> (A) -> ((D) -> C) {
  return { a in
    flatMap(rhs, lhs(a))
  }
}

@inlinable
public func void<T>(_ f: @escaping (()) -> T) -> () -> T {
  return { f(()) }
}

@inlinable
public func void<T>(_ f: @escaping (()) throws -> T) -> (() throws -> T) {
  return { try f(()) }
}

@inlinable
public func void<T>(_ f: @escaping (Unit) -> T) -> () -> T {
  return { f(unit) }
}

@inlinable
public func void<T>(_ f: @escaping (Unit) throws -> T) -> (() throws -> T) {
  return { try f(unit) }
}

@inlinable
public func wcatch<A, B>(_ f: @escaping (A) throws -> B) -> ((A) -> B?) {
  return { try? f($0) }
}
