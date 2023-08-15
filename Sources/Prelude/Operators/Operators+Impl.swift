@inlinable
public func id<Value>(_ value: Value) -> Value { value }

// MARK: - Compose

@inlinable
public func <<< <A, B, C>(
  _ b2c: @escaping (B) -> C,
  _ a2b: @escaping (A) -> B
) -> (A) -> C {
  return { a in b2c(a2b(a)) }
}

@inlinable
public func <<< <A, B, C>(
  _ b2c: @escaping (B) throws -> C,
  _ a2b: @escaping (A) throws -> B
) -> (A) throws -> C {
  return { a in try b2c(a2b(a)) }
}

@inlinable
public func <<< <A, B, C>(
  _ b2c: @escaping (B) async -> C,
  _ a2b: @escaping (A) async -> B
) -> (A) async -> C {
  return { a in await b2c(a2b(a)) }
}

@inlinable
public func <<< <A, B, C>(
  _ b2c: @escaping (B) async throws -> C,
  _ a2b: @escaping (A) async throws -> B
) -> (A) async throws -> C {
  return { a in try await b2c(a2b(a)) }
}

// MARK: - Pipe

@inlinable
public func >>> <A, B, C>(
  _ a2b: @escaping (A) -> B,
  _ b2c: @escaping (B) -> C
) -> (A) -> C {
  return { a in b2c(a2b(a)) }
}

@inlinable
public func >>> <A, B, C>(
  _ a2b: @escaping (A) throws -> B,
  _ b2c: @escaping (B) throws -> C
) -> ((A) throws -> C) {
  return { a in try b2c(a2b(a)) }
}

@inlinable
public func >>> <A, B, C>(
  _ a2b: @escaping (A) async -> B,
  _ b2c: @escaping (B) async -> C
) -> ((A) async -> C) {
  return { a in await b2c(a2b(a)) }
}

@inlinable
public func >>> <A, B, C>(
  _ a2b: @escaping (A) async throws -> B,
  _ b2c: @escaping (B) async throws -> C
) -> ((A) async throws -> C) {
  return { a in try await b2c(a2b(a)) }
}

// MARK: - Apply

@inlinable
public func <| <A, B> (
  f: (A) throws -> B,
  a: A
) rethrows -> B {
  return try f(a)
}

@inlinable
public func <| <A, B> (
  f: (A) async throws -> B,
  a: A
) async rethrows -> B {
  return try await f(a)
}

@inlinable
public func |> <A, B> (
  a: A,
  f: (A) throws -> B
) rethrows -> B {
  return try f(a)
}

@inlinable
public func |> <A, B> (
  a: A,
  f: (A) async throws -> B
) async rethrows -> B {
  return try await f(a)
}

// MARK: - Bind/Monad

@inlinable
public func flatMap <A, B, C>(
  _ lhs: @escaping (B) -> ((A) -> C),
  _ rhs: @escaping (A) -> B
) -> (A) -> C {
  return { a in
    lhs(rhs(a))(a)
  }
}

@inlinable
public func >=> <A, B, C, D>(
  lhs: @escaping (A) -> ((D) -> B),
  rhs: @escaping (B) -> ((D) -> C)
) -> (A) -> ((D) -> C) {
  return { a in
    flatMap(rhs, lhs(a))
  }
}

/// Wrapping catch
///
/// Maps throwable block to Optional
@inlinable
public func wcatch<A, B>(_ f: @escaping (A) throws -> B) -> ((A) -> B?) {
  return { try? f($0) }
}
