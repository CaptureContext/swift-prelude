public func compose<A, B, C>(
  _ b2c: @escaping (B) -> C,
  _ a2b: @escaping (A) -> B
) -> (A) -> C {
  return { a in b2c(a2b(a)) }
}

public func compose<A, B, C, D>(
  _ c2d: @escaping (C) -> D,
  _ b2c: @escaping (B) -> C,
  _ a2b: @escaping (A) -> B
) -> (A) -> D {
  return { a in c2d(b2c(a2b(a))) }
}

public func compose<A, B, C, D, E>(
  _ d2e: @escaping (D) -> E,
  _ c2d: @escaping (C) -> D,
  _ b2c: @escaping (B) -> C,
  _ a2b: @escaping (A) -> B
) -> (A) -> E {
  return { a in d2e(c2d(b2c(a2b(a)))) }
}

public func compose<A, B, C, D, E, F>(
  _ e2f: @escaping (E) -> F,
  _ d2e: @escaping (D) -> E,
  _ c2d: @escaping (C) -> D,
  _ b2c: @escaping (B) -> C,
  _ a2b: @escaping (A) -> B
) -> (A) -> F {
  return { a in e2f(d2e(c2d(b2c(a2b(a))))) }
}

public func compose<A, B, C, D, E, F, G>(
  _ f2g: @escaping (F) -> G,
  _ e2f: @escaping (E) -> F,
  _ d2e: @escaping (D) -> E,
  _ c2d: @escaping (C) -> D,
  _ b2c: @escaping (B) -> C,
  _ a2b: @escaping (A) -> B
) -> (A) -> G {
  return { a in f2g(e2f(d2e(c2d(b2c(a2b(a)))))) }
}

public func compose<A, B, C, D, E, F, G, H>(
  _ g2h: @escaping (G) -> H,
  _ f2g: @escaping (F) -> G,
  _ e2f: @escaping (E) -> F,
  _ d2e: @escaping (D) -> E,
  _ c2d: @escaping (C) -> D,
  _ b2c: @escaping (B) -> C,
  _ a2b: @escaping (A) -> B
) -> (A) -> H {
  return { a in g2h(f2g(e2f(d2e(c2d(b2c(a2b(a))))))) }
}
