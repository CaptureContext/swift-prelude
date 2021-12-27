public func pipe<A, B, C>(
  _ a2b: @escaping (A) -> B,
  _ b2c: @escaping (B) -> C
) -> (A) -> C {
  return { a in b2c(a2b(a)) }
}

public func pipe<A, B, C, D>(
  _ a2b: @escaping (A) -> B,
  _ b2c: @escaping (B) -> C,
  _ c2d: @escaping (C) -> D
) -> (A) -> D {
  return { a in c2d(b2c(a2b(a))) }
}

public func pipe<A, B, C, D, E>(
  _ a2b: @escaping (A) -> B,
  _ b2c: @escaping (B) -> C,
  _ c2d: @escaping (C) -> D,
  _ d2e: @escaping (D) -> E
) -> (A) -> E {
  return { a in d2e(c2d(b2c(a2b(a)))) }
}

public func pipe<A, B, C, D, E, F>(
  _ a2b: @escaping (A) -> B,
  _ b2c: @escaping (B) -> C,
  _ c2d: @escaping (C) -> D,
  _ d2e: @escaping (D) -> E,
  _ e2f: @escaping (E) -> F
) -> (A) -> F {
  return { a in e2f(d2e(c2d(b2c(a2b(a))))) }
}

public func pipe<A, B, C, D, E, F, G>(
  _ a2b: @escaping (A) -> B,
  _ b2c: @escaping (B) -> C,
  _ c2d: @escaping (C) -> D,
  _ d2e: @escaping (D) -> E,
  _ e2f: @escaping (E) -> F,
  _ f2g: @escaping (F) -> G
) -> (A) -> G {
  return { a in f2g(e2f(d2e(c2d(b2c(a2b(a)))))) }
}

public func pipe<A, B, C, D, E, F, G, H>(
  _ a2b: @escaping (A) -> B,
  _ b2c: @escaping (B) -> C,
  _ c2d: @escaping (C) -> D,
  _ d2e: @escaping (D) -> E,
  _ e2f: @escaping (E) -> F,
  _ f2g: @escaping (F) -> G,
  _ g2h: @escaping (G) -> H
) -> (A) -> H {
  return { a in g2h(f2g(e2f(d2e(c2d(b2c(a2b(a))))))) }
}
