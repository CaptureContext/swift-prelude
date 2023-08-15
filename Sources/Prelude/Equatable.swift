@inlinable
public func equal<A: Equatable>(to a: A) -> (A) -> Bool {
  return curry(==) <| a
}

@inlinable
public func == <A, B: Equatable>(f: @escaping (A) -> B, g: @escaping (A) -> B) -> (A) -> Bool {
  return { a in f(a) == g(a) }
}

@inlinable
public func != <A, B: Equatable>(f: @escaping (A) -> B, g: @escaping (A) -> B) -> (A) -> Bool {
  return { a in f(a) != g(a) }
}

@inlinable
public func == <A, B: Equatable>(f: @escaping (A) -> B, x: B) -> (A) -> Bool {
  return f == const(x)
}

@inlinable
public func != <A, B: Equatable>(f: @escaping (A) -> B, x: B) -> (A) -> Bool {
  return f != const(x)
}
