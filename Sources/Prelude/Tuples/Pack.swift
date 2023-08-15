@inlinable
public func unpack<T>(
  _ f: @escaping (()) -> T
) -> () -> T {
  return { f(()) }
}

@inlinable
public func unpack<A, T>(
  _ f: @escaping ((A)) -> T
) -> (A) -> T {
  return { f(($0)) }
}

@inlinable
public func unpack<A, B, T>(
  _ f: @escaping ((A, B)) -> T
) -> (A, B) -> T {
  return { f(($0, $1)) }
}

@inlinable
public func unpack<A, B, C, T>(
  _ f: @escaping ((A, B, C)) -> T
) -> (A, B, C) -> T {
  return { f(($0, $1, $2)) }
}

@inlinable
public func unpack<A, B, C, D, T>(
  _ f: @escaping ((A, B, C, D)) -> T
) -> (A, B, C, D) -> T {
  return { f(($0, $1, $2, $3)) }
}

@inlinable
public func unpack<A, B, C, D, E, T>(
  _ f: @escaping ((A, B, C, D, E)) -> T
) -> (A, B, C, D, E) -> T {
  return { f(($0, $1, $2, $3, $4)) }
}

@inlinable
public func pack<T>(
  _ f: @escaping () -> T
) -> (()) -> T {
  return { _ in f() }
}

@inlinable
public func pack<A, T>(
  _ f: @escaping (A) -> T
) -> ((A)) -> T {
  return { f(($0)) }
}

@inlinable
public func pack<A, B, T>(
  _ f: @escaping (A, B) -> T
) -> ((A, B)) -> T {
  return { f($0.0, $0.1) }
}

@inlinable
public func pack<A, B, C, T>(
  _ f: @escaping (A, B, C) -> T
) -> ((A, B, C)) -> T {
  return { f($0.0, $0.1, $0.2) }
}

@inlinable
public func pack<A, B, C, D, T>(
  _ f: @escaping (A, B, C, D) -> T
) -> ((A, B, C, D)) -> T {
  return { f($0.0, $0.1, $0.2, $0.3) }
}

@inlinable
public func pack<A, B, C, D, E, T>(
  _ f: @escaping (A, B, C, D, E) -> T
) -> ((A, B, C, D, E)) -> T {
  return { f($0.0, $0.1, $0.2, $0.3, $0.4) }
}

@inlinable
public func fpack<T, A, B>(
  _ f1: @escaping (T) -> A,
  _ f2: @escaping (T) -> B
) -> (T) -> (A, B) {
  return { (f1($0), f2($0)) }
}

@inlinable
public func fpack<T, A, B, C>(
  _ f1: @escaping (T) -> A,
  _ f2: @escaping (T) -> B,
  _ f3: @escaping (T) -> C
) -> (T) -> (A, B, C) {
  return { (f1($0), f2($0), f3($0)) }
}

@inlinable
public func fpack<T, A, B, C, D>(
  _ f1: @escaping (T) -> A,
  _ f2: @escaping (T) -> B,
  _ f3: @escaping (T) -> C,
  _ f4: @escaping (T) -> D
) -> (T) -> (A, B, C, D) {
  return { (f1($0), f2($0), f3($0), f4($0)) }
}

@inlinable
public func fpack<T, A, B, C, D, E>(
  _ f1: @escaping (T) -> A,
  _ f2: @escaping (T) -> B,
  _ f3: @escaping (T) -> C,
  _ f4: @escaping (T) -> D,
  _ f5: @escaping (T) -> E
) -> (T) -> (A, B, C, D, E) {
  return { (f1($0), f2($0), f3($0), f4($0), f5($0)) }
}

// MARK: - Throwing

@inlinable
public func unpack<T>(
  _ f: @escaping (()) throws -> T
) -> () throws -> T {
  return { try f(()) }
}

@inlinable
public func unpack<A, T>(
  _ f: @escaping ((A)) throws -> T
) -> (A) throws -> T {
  return { try f(($0)) }
}

@inlinable
public func unpack<A, B, T>(
  _ f: @escaping ((A, B)) throws -> T
) -> (A, B) throws -> T {
  return { try f(($0, $1)) }
}

@inlinable
public func unpack<A, B, C, T>(
  _ f: @escaping ((A, B, C)) throws -> T
) -> (A, B, C) throws -> T {
  return { try f(($0, $1, $2)) }
}

@inlinable
public func unpack<A, B, C, D, T>(
  _ f: @escaping ((A, B, C, D)) throws -> T
) -> (A, B, C, D) throws -> T {
  return { try f(($0, $1, $2, $3)) }
}

@inlinable
public func unpack<A, B, C, D, E, T>(
  _ f: @escaping ((A, B, C, D, E)) throws -> T
) -> (A, B, C, D, E) throws -> T {
  return { try f(($0, $1, $2, $3, $4)) }
}

@inlinable
public func pack<T>(
  _ f: @escaping () throws -> T
) -> (()) throws -> T {
  return { _ in try f() }
}

@inlinable
public func pack<A, T>(
  _ f: @escaping (A) throws -> T
) -> ((A)) throws -> T {
  return { try f(($0)) }
}

@inlinable
public func pack<A, B, T>(
  _ f: @escaping (A, B) throws -> T
) -> ((A, B)) throws -> T {
  return { try f($0.0, $0.1) }
}

@inlinable
public func pack<A, B, C, T>(
  _ f: @escaping (A, B, C) throws -> T
) -> ((A, B, C)) throws -> T {
  return { try f($0.0, $0.1, $0.2) }
}

@inlinable
public func pack<A, B, C, D, T>(
  _ f: @escaping (A, B, C, D) throws -> T
) -> ((A, B, C, D)) throws -> T {
  return { try f($0.0, $0.1, $0.2, $0.3) }
}

@inlinable
public func pack<A, B, C, D, E, T>(
  _ f: @escaping (A, B, C, D, E) throws -> T
) -> ((A, B, C, D, E)) throws -> T {
  return { try f($0.0, $0.1, $0.2, $0.3, $0.4) }
}
