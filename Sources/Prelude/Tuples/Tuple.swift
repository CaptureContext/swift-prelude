public func tuple<A, B>(_ x: A)
-> (B) -> (A, B) {
  return { y in (x, y) }
}

public func tuple3<A, B, C>(_ a: A)
-> (B) -> (C) -> (A, B, C) {
  return { b in { c in (a, b, c) } }
}

public func tuple4<A, B, C, D>(_ a: A)
-> (B) -> (C) -> (D) -> (A, B, C, D) {
  return { b in { c in { d in (a, b, c, d) } } }
}

public func tuple5<A, B, C, D, E>(_ a: A)
-> (B) -> (C) -> (D) -> (E) -> (A, B, C, D, E) {
  return { b in { c in { d in { e in (a, b, c, d, e) } } } }
}

public func first<A, B>(_ x: (A, B)) -> A {
  return x.0
}

public func first<A, B, C>(_ x: (A, B, C)) -> A {
  return x.0
}

public func second<A, B>(_ x: (A, B)) -> B {
  return x.1
}

public func second<A, B, C>(_ x: (A, B, C)) -> B {
  return x.1
}

public func third<A, B, C>(_ x: (A, B, C)) -> C {
  return x.2
}

public func mapFirst<A, B, C>(
  _ a2b: @escaping (A) -> B
) -> ((A, C)) -> (B, C) {
  return { ac in (a2b(ac.0), ac.1) }
}

public func mapSecond<A, B, C>(
  _ b2c: @escaping (B) -> C
) -> ((A, B)) -> (A, C) {
  return { ab in (ab.0, b2c(ab.1)) }
}

public func mapTuple<A, B, C, D>(
  first: @escaping (A) -> C,
  second: @escaping (B) -> D
) -> (A, B) -> (C, D) {
  return { (first($0), second($1)) }
}

// MARK: - Semigroupoid

public func >>> <A, B, C>(_ ab: (A, B), _ bc: (B, C)) -> (A, C) {
  return (ab.0, bc.1)
}

public func <<< <A, B, C>(_ bc: (B, C), _ ab: (A, B)) -> (A, C) {
  return (ab.0, bc.1)
}

// MARK: - Semigroup

public func <> <A: Semigroup, B: Semigroup>(_ ab1: (A, B), _ ab2: (A, B)) -> (A, B) {
  return (ab1.0 <> ab2.0, ab1.1 <> ab2.1)
}

// MARK: - Monoid

public func empty<A: Monoid, B: Monoid>() -> (A, B) {
  return (A.empty, B.empty)
}
