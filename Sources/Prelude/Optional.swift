@inlinable
public func optional<A, B>(
  _ default: @autoclosure @escaping () -> B
) -> (@escaping (A) -> B) -> (A?) -> B {
  return { a2b in
    { a in
      a.map(a2b) ?? `default`()
    }
  }
}

@inlinable
public func coalesce<A>(
  with default: @autoclosure @escaping () -> A
) -> (A?) -> A {
  return optional(`default`()) <| id
}


extension Optional {
  @inlinable
  public func `do`(_ f: (Wrapped) -> Void) {
    if let x = self { f(x) }
  }
}

// MARK: - Functor

extension Optional {
  @inlinable
  public static func <¢> <A>(
    f: (Wrapped) -> A,
    x: Optional
  ) -> A? {
    return x.map(f)
  }
}

@inlinable
public func map<A, B>(
  _ a2b: @escaping (A) -> B
) -> (A?) -> B? {
  return { a in
    a2b <¢> a
  }
}

// MARK: - Apply

extension Optional {
  @inlinable
  public func apply<A>(
    _ f: ((Wrapped) -> A)?
  ) -> A? {
    // return f.flatMap(self.map) // https://bugs.swift.org/browse/SR-5422
    guard let f = f, let a = self else { return nil }
    return f(a)
  }
  
  public static func <*> <A>(f: ((Wrapped) -> A)?, x: Optional) -> A? {
    return x.apply(f)
  }
}

@inlinable
public func apply<A, B>(
  _ a2b: ((A) -> B)?
) -> (A?) -> B? {
  return { a in
    a2b <*> a
  }
}

// MARK: - Applicative

@inlinable
public func pure<A>(_ a: A) -> A? {
  return .some(a)
}

// MARK: - Traversable

@inlinable
public func traverse<S, A, B>(
  _ f: @escaping (A) -> B?
) -> (S) -> [B]?
where S: Sequence, S.Element == A {
  return { xs in
    var ys: [B] = []
    for x in xs {
      guard let y = f(x) else { return nil }
      ys.append(y)
    }
    return ys
  }
}

@inlinable
public func sequence<A>(_ xs: [A?]) -> [A]? {
  return xs |> traverse(id)
}

// MARK: - Bind/Monad

@inlinable
public func flatMap<A, B>(
  _ a2b: @escaping (A) -> B?
) -> (A?) -> B? {
  return { a in
    a.flatMap(a2b)
  }
}

@inlinable
public func >=> <A, B, C>(
  lhs: @escaping (A) -> B?,
  rhs: @escaping (B) -> C?
) -> (A) -> C? {
  return lhs >>> flatMap(rhs)
}

// MARK: - Semigroup

extension Optional: Semigroup where Wrapped: Semigroup {
  @inlinable
  public static func <> (lhs: Optional, rhs: Optional) -> Optional {
    switch (lhs, rhs) {
    case (.none, _):
      return rhs
    case (_, .none):
      return lhs
    case let (.some(l), .some(r)):
      return .some(l <> r)
    }
  }
}

// MARK: - Monoid

extension Optional: Monoid where Wrapped: Semigroup {
  @inlinable
  public static var empty: Optional {
    return .none
  }
}

// MARK: - Foldable/Sequence

extension Optional {
  @inlinable
  public func foldMap<M: Monoid>(
    _ f: @escaping (Wrapped) -> M
  ) -> M {
    return self.map(f) ?? M.empty
  }
}

@inlinable
public func foldMap<A, M: Monoid>(
  _ f: @escaping (A) -> M
) -> (A?) -> M {
  return { xs in
    xs.foldMap(f)
  }
}
