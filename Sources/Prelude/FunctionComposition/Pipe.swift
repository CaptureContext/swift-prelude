@inlinable
public func pipe<A, B, C>(
  _ a2b: @escaping (A) -> B,
  _ b2c: @escaping (B) -> C
) -> (A) -> C {
  return { a in b2c(a2b(a)) }
}

@inlinable
public func pipe<A, B, C, D>(
  _ a2b: @escaping (A) -> B,
  _ b2c: @escaping (B) -> C,
  _ c2d: @escaping (C) -> D
) -> (A) -> D {
  return { a in c2d(b2c(a2b(a))) }
}

@inlinable
public func pipe<A, B, C, D, E>(
  _ a2b: @escaping (A) -> B,
  _ b2c: @escaping (B) -> C,
  _ c2d: @escaping (C) -> D,
  _ d2e: @escaping (D) -> E
) -> (A) -> E {
  return { a in d2e(c2d(b2c(a2b(a)))) }
}

@inlinable
public func pipe<A, B, C, D, E, F>(
  _ a2b: @escaping (A) -> B,
  _ b2c: @escaping (B) -> C,
  _ c2d: @escaping (C) -> D,
  _ d2e: @escaping (D) -> E,
  _ e2f: @escaping (E) -> F
) -> (A) -> F {
  return { a in e2f(d2e(c2d(b2c(a2b(a))))) }
}

@inlinable
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

@inlinable
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

@inlinable
public func pipe<A, B, C>(
  _ a2b: @escaping (A) throws -> B,
  _ b2c: @escaping (B) throws -> C
) -> (A) throws -> C {
  return { a in try b2c(a2b(a)) }
}

@inlinable
public func pipe<A, B, C, D>(
  _ a2b: @escaping (A) throws -> B,
  _ b2c: @escaping (B) throws -> C,
  _ c2d: @escaping (C) throws -> D
) -> (A) throws -> D {
  return { a in try c2d(b2c(a2b(a))) }
}

@inlinable
public func pipe<A, B, C, D, E>(
  _ a2b: @escaping (A) throws -> B,
  _ b2c: @escaping (B) throws -> C,
  _ c2d: @escaping (C) throws -> D,
  _ d2e: @escaping (D) throws -> E
) -> (A) throws -> E {
  return { a in try d2e(c2d(b2c(a2b(a)))) }
}

@inlinable
public func pipe<A, B, C, D, E, F>(
  _ a2b: @escaping (A) throws -> B,
  _ b2c: @escaping (B) throws -> C,
  _ c2d: @escaping (C) throws -> D,
  _ d2e: @escaping (D) throws -> E,
  _ e2f: @escaping (E) throws -> F
) -> (A) throws -> F {
  return { a in try e2f(d2e(c2d(b2c(a2b(a))))) }
}

@inlinable
public func pipe<A, B, C, D, E, F, G>(
  _ a2b: @escaping (A) throws -> B,
  _ b2c: @escaping (B) throws -> C,
  _ c2d: @escaping (C) throws -> D,
  _ d2e: @escaping (D) throws -> E,
  _ e2f: @escaping (E) throws -> F,
  _ f2g: @escaping (F) throws -> G
) -> (A) throws -> G {
  return { a in try f2g(e2f(d2e(c2d(b2c(a2b(a)))))) }
}

@inlinable
public func pipe<A, B, C, D, E, F, G, H>(
  _ a2b: @escaping (A) throws -> B,
  _ b2c: @escaping (B) throws -> C,
  _ c2d: @escaping (C) throws -> D,
  _ d2e: @escaping (D) throws -> E,
  _ e2f: @escaping (E) throws -> F,
  _ f2g: @escaping (F) throws -> G,
  _ g2h: @escaping (G) throws -> H
) -> (A) throws -> H {
  return { a in try g2h(f2g(e2f(d2e(c2d(b2c(a2b(a))))))) }
}

@inlinable
public func pipe<A, B, C>(
  _ a2b: @escaping (A) async -> B,
  _ b2c: @escaping (B) async -> C
) -> (A) async -> C {
  return { a in await b2c(a2b(a)) }
}

@inlinable
public func pipe<A, B, C, D>(
  _ a2b: @escaping (A) async -> B,
  _ b2c: @escaping (B) async -> C,
  _ c2d: @escaping (C) async -> D
) -> (A) async -> D {
  return { a in await c2d(b2c(a2b(a))) }
}

@inlinable
public func pipe<A, B, C, D, E>(
  _ a2b: @escaping (A) async -> B,
  _ b2c: @escaping (B) async -> C,
  _ c2d: @escaping (C) async -> D,
  _ d2e: @escaping (D) async -> E
) -> (A) async -> E {
  return { a in await d2e(c2d(b2c(a2b(a)))) }
}

@inlinable
public func pipe<A, B, C, D, E, F>(
  _ a2b: @escaping (A) async -> B,
  _ b2c: @escaping (B) async -> C,
  _ c2d: @escaping (C) async -> D,
  _ d2e: @escaping (D) async -> E,
  _ e2f: @escaping (E) async -> F
) -> (A) async -> F {
  return { a in await e2f(d2e(c2d(b2c(a2b(a))))) }
}

@inlinable
public func pipe<A, B, C, D, E, F, G>(
  _ a2b: @escaping (A) async -> B,
  _ b2c: @escaping (B) async -> C,
  _ c2d: @escaping (C) async -> D,
  _ d2e: @escaping (D) async -> E,
  _ e2f: @escaping (E) async -> F,
  _ f2g: @escaping (F) async -> G
) -> (A) async -> G {
  return { a in await f2g(e2f(d2e(c2d(b2c(a2b(a)))))) }
}

@inlinable
public func pipe<A, B, C, D, E, F, G, H>(
  _ a2b: @escaping (A) async -> B,
  _ b2c: @escaping (B) async -> C,
  _ c2d: @escaping (C) async -> D,
  _ d2e: @escaping (D) async -> E,
  _ e2f: @escaping (E) async -> F,
  _ f2g: @escaping (F) async -> G,
  _ g2h: @escaping (G) async -> H
) -> (A) async -> H {
  return { a in await g2h(f2g(e2f(d2e(c2d(b2c(a2b(a))))))) }
}

@inlinable
public func pipe<A, B, C>(
  _ a2b: @escaping (A) async throws -> B,
  _ b2c: @escaping (B) async throws -> C
) -> (A) async throws -> C {
  return { a in try await b2c(a2b(a)) }
}

@inlinable
public func pipe<A, B, C, D>(
  _ a2b: @escaping (A) async throws -> B,
  _ b2c: @escaping (B) async throws -> C,
  _ c2d: @escaping (C) async throws -> D
) -> (A) async throws -> D {
  return { a in try await c2d(b2c(a2b(a))) }
}

@inlinable
public func pipe<A, B, C, D, E>(
  _ a2b: @escaping (A) async throws -> B,
  _ b2c: @escaping (B) async throws -> C,
  _ c2d: @escaping (C) async throws -> D,
  _ d2e: @escaping (D) async throws -> E
) -> (A) async throws -> E {
  return { a in try await d2e(c2d(b2c(a2b(a)))) }
}

@inlinable
public func pipe<A, B, C, D, E, F>(
  _ a2b: @escaping (A) async throws -> B,
  _ b2c: @escaping (B) async throws -> C,
  _ c2d: @escaping (C) async throws -> D,
  _ d2e: @escaping (D) async throws -> E,
  _ e2f: @escaping (E) async throws -> F
) -> (A) async throws -> F {
  return { a in try await e2f(d2e(c2d(b2c(a2b(a))))) }
}

@inlinable
public func pipe<A, B, C, D, E, F, G>(
  _ a2b: @escaping (A) async throws -> B,
  _ b2c: @escaping (B) async throws -> C,
  _ c2d: @escaping (C) async throws -> D,
  _ d2e: @escaping (D) async throws -> E,
  _ e2f: @escaping (E) async throws -> F,
  _ f2g: @escaping (F) async throws -> G
) -> (A) async throws -> G {
  return { a in try await f2g(e2f(d2e(c2d(b2c(a2b(a)))))) }
}

@inlinable
public func pipe<A, B, C, D, E, F, G, H>(
  _ a2b: @escaping (A) async throws -> B,
  _ b2c: @escaping (B) async throws -> C,
  _ c2d: @escaping (C) async throws -> D,
  _ d2e: @escaping (D) async throws -> E,
  _ e2f: @escaping (E) async throws -> F,
  _ f2g: @escaping (F) async throws -> G,
  _ g2h: @escaping (G) async throws -> H
) -> (A) async throws -> H {
  return { a in try await g2h(f2g(e2f(d2e(c2d(b2c(a2b(a))))))) }
}
