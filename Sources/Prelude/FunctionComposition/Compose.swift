@inlinable
public func compose<A, B, C>(
  _ b2c: @escaping (B) -> C,
  _ a2b: @escaping (A) -> B
) -> (A) -> C {
  return { a in b2c(a2b(a)) }
}

@inlinable
public func compose<A, B, C, D>(
  _ c2d: @escaping (C) -> D,
  _ b2c: @escaping (B) -> C,
  _ a2b: @escaping (A) -> B
) -> (A) -> D {
  return { a in c2d(b2c(a2b(a))) }
}

@inlinable
public func compose<A, B, C, D, E>(
  _ d2e: @escaping (D) -> E,
  _ c2d: @escaping (C) -> D,
  _ b2c: @escaping (B) -> C,
  _ a2b: @escaping (A) -> B
) -> (A) -> E {
  return { a in d2e(c2d(b2c(a2b(a)))) }
}

@inlinable
public func compose<A, B, C, D, E, F>(
  _ e2f: @escaping (E) -> F,
  _ d2e: @escaping (D) -> E,
  _ c2d: @escaping (C) -> D,
  _ b2c: @escaping (B) -> C,
  _ a2b: @escaping (A) -> B
) -> (A) -> F {
  return { a in e2f(d2e(c2d(b2c(a2b(a))))) }
}

@inlinable
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

@inlinable
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

@inlinable
public func compose<A, B, C>(
  _ b2c: @escaping (B) throws -> C,
  _ a2b: @escaping (A) throws -> B
) -> (A) throws -> C {
  return { a in try b2c(a2b(a)) }
}

@inlinable
public func compose<A, B, C, D>(
  _ c2d: @escaping (C) throws -> D,
  _ b2c: @escaping (B) throws -> C,
  _ a2b: @escaping (A) throws -> B
) -> (A) throws -> D {
  return { a in try c2d(b2c(a2b(a))) }
}

@inlinable
public func compose<A, B, C, D, E>(
  _ d2e: @escaping (D) throws -> E,
  _ c2d: @escaping (C) throws -> D,
  _ b2c: @escaping (B) throws -> C,
  _ a2b: @escaping (A) throws -> B
) -> (A) throws -> E {
  return { a in try d2e(c2d(b2c(a2b(a)))) }
}

@inlinable
public func compose<A, B, C, D, E, F>(
  _ e2f: @escaping (E) throws -> F,
  _ d2e: @escaping (D) throws -> E,
  _ c2d: @escaping (C) throws -> D,
  _ b2c: @escaping (B) throws -> C,
  _ a2b: @escaping (A) throws -> B
) -> (A) throws -> F {
  return { a in try e2f(d2e(c2d(b2c(a2b(a))))) }
}

@inlinable
public func compose<A, B, C, D, E, F, G>(
  _ f2g: @escaping (F) throws -> G,
  _ e2f: @escaping (E) throws -> F,
  _ d2e: @escaping (D) throws -> E,
  _ c2d: @escaping (C) throws -> D,
  _ b2c: @escaping (B) throws -> C,
  _ a2b: @escaping (A) throws -> B
) -> (A) throws -> G {
  return { a in try f2g(e2f(d2e(c2d(b2c(a2b(a)))))) }
}

@inlinable
public func compose<A, B, C, D, E, F, G, H>(
  _ g2h: @escaping (G) throws -> H,
  _ f2g: @escaping (F) throws -> G,
  _ e2f: @escaping (E) throws -> F,
  _ d2e: @escaping (D) throws -> E,
  _ c2d: @escaping (C) throws -> D,
  _ b2c: @escaping (B) throws -> C,
  _ a2b: @escaping (A) throws -> B
) -> (A) throws -> H {
  return { a in try g2h(f2g(e2f(d2e(c2d(b2c(a2b(a))))))) }
}

@inlinable
public func compose<A, B, C>(
  _ b2c: @escaping (B) async -> C,
  _ a2b: @escaping (A) async -> B
) -> (A) async -> C {
  return { a in await b2c(a2b(a)) }
}

@inlinable
public func compose<A, B, C, D>(
  _ c2d: @escaping (C) async -> D,
  _ b2c: @escaping (B) async -> C,
  _ a2b: @escaping (A) async -> B
) -> (A) async -> D {
  return { a in await c2d(b2c(a2b(a))) }
}

@inlinable
public func compose<A, B, C, D, E>(
  _ d2e: @escaping (D) async -> E,
  _ c2d: @escaping (C) async -> D,
  _ b2c: @escaping (B) async -> C,
  _ a2b: @escaping (A) async -> B
) -> (A) async -> E {
  return { a in await d2e(c2d(b2c(a2b(a)))) }
}

@inlinable
public func compose<A, B, C, D, E, F>(
  _ e2f: @escaping (E) async -> F,
  _ d2e: @escaping (D) async -> E,
  _ c2d: @escaping (C) async -> D,
  _ b2c: @escaping (B) async -> C,
  _ a2b: @escaping (A) async -> B
) -> (A) async -> F {
  return { a in await e2f(d2e(c2d(b2c(a2b(a))))) }
}

@inlinable
public func compose<A, B, C, D, E, F, G>(
  _ f2g: @escaping (F) async -> G,
  _ e2f: @escaping (E) async -> F,
  _ d2e: @escaping (D) async -> E,
  _ c2d: @escaping (C) async -> D,
  _ b2c: @escaping (B) async -> C,
  _ a2b: @escaping (A) async -> B
) -> (A) async -> G {
  return { a in await f2g(e2f(d2e(c2d(b2c(a2b(a)))))) }
}

@inlinable
public func compose<A, B, C, D, E, F, G, H>(
  _ g2h: @escaping (G) async -> H,
  _ f2g: @escaping (F) async -> G,
  _ e2f: @escaping (E) async -> F,
  _ d2e: @escaping (D) async -> E,
  _ c2d: @escaping (C) async -> D,
  _ b2c: @escaping (B) async -> C,
  _ a2b: @escaping (A) async -> B
) -> (A) async -> H {
  return { a in await g2h(f2g(e2f(d2e(c2d(b2c(a2b(a))))))) }
}

@inlinable
public func compose<A, B, C>(
  _ b2c: @escaping (B) async throws -> C,
  _ a2b: @escaping (A) async throws -> B
) -> (A) async throws -> C {
  return { a in try await b2c(a2b(a)) }
}

@inlinable
public func compose<A, B, C, D>(
  _ c2d: @escaping (C) async throws -> D,
  _ b2c: @escaping (B) async throws -> C,
  _ a2b: @escaping (A) async throws -> B
) -> (A) async throws -> D {
  return { a in try await c2d(b2c(a2b(a))) }
}

@inlinable
public func compose<A, B, C, D, E>(
  _ d2e: @escaping (D) async throws -> E,
  _ c2d: @escaping (C) async throws -> D,
  _ b2c: @escaping (B) async throws -> C,
  _ a2b: @escaping (A) async throws -> B
) -> (A) async throws -> E {
  return { a in try await d2e(c2d(b2c(a2b(a)))) }
}

@inlinable
public func compose<A, B, C, D, E, F>(
  _ e2f: @escaping (E) async throws -> F,
  _ d2e: @escaping (D) async throws -> E,
  _ c2d: @escaping (C) async throws -> D,
  _ b2c: @escaping (B) async throws -> C,
  _ a2b: @escaping (A) async throws -> B
) -> (A) async throws -> F {
  return { a in try await e2f(d2e(c2d(b2c(a2b(a))))) }
}

@inlinable
public func compose<A, B, C, D, E, F, G>(
  _ f2g: @escaping (F) async throws -> G,
  _ e2f: @escaping (E) async throws -> F,
  _ d2e: @escaping (D) async throws -> E,
  _ c2d: @escaping (C) async throws -> D,
  _ b2c: @escaping (B) async throws -> C,
  _ a2b: @escaping (A) async throws -> B
) -> (A) async throws -> G {
  return { a in try await f2g(e2f(d2e(c2d(b2c(a2b(a)))))) }
}

@inlinable
public func compose<A, B, C, D, E, F, G, H>(
  _ g2h: @escaping (G) async throws -> H,
  _ f2g: @escaping (F) async throws -> G,
  _ e2f: @escaping (E) async throws -> F,
  _ d2e: @escaping (D) async throws -> E,
  _ c2d: @escaping (C) async throws -> D,
  _ b2c: @escaping (B) async throws -> C,
  _ a2b: @escaping (A) async throws -> B
) -> (A) async throws -> H {
  return { a in try await g2h(f2g(e2f(d2e(c2d(b2c(a2b(a))))))) }
}
