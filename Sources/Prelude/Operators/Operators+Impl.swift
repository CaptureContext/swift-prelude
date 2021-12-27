public func id<Value>(_ value: Value) -> Value { value }

// MARK: - Compose

public func <<< <A, B, C>(
  _ b2c: @escaping (B) -> C,
  _ a2b: @escaping (A) -> B
) -> (A) -> C {
  return { a in b2c(a2b(a)) }
}

// MARK: - Pipe

public func >>> <A, B, C>(
  _ a2b: @escaping (A) -> B,
  _ b2c: @escaping (B) -> C
) -> (A) -> C {
  return { a in b2c(a2b(a)) }
}

// MARK: - Apply

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

/// Wrapping catch
///
/// Maps throwable block to Optional
@inlinable
public func wcatch<A, B>(_ f: @escaping (A) throws -> B) -> ((A) -> B?) {
  return { try? f($0) }
}
