@inlinable
public func scope<A, B>(
  _ f: @escaping (A) -> B
) -> (A) -> (B) {
  return { f($0) }
}

@inlinable
public func scope<A, B>(
  _ f: @escaping (A) -> B
) -> (A, A) -> (B, B) {
  return { (f($0), f($1)) }
}

@inlinable
public func scope<A, B>(
  _ f: @escaping (A) -> B
) -> (A, A, A) -> (B, B, B) {
  return { (f($0), f($1), f($2)) }
}

@inlinable
public func scope<A, B>(
  _ f: @escaping (A) -> B
) -> (A, A, A, A) -> (B, B, B, B) {
  return { (f($0), f($1), f($2), f($3)) }
}

@inlinable
public func scope<A, B>(
  _ f: @escaping (A) -> B
) -> (A, A, A, A, A) -> (B, B, B, B, B) {
  return { (f($0), f($1), f($2), f($3), f($4)) }
}
