@inlinable
public func catOptionals<S: Sequence, A>(_ xs: S) -> [A] where S.Element == A? {
  return xs |> mapOptional(id)
}

@inlinable
public func mapOptional<S: Sequence, A>(_ f: @escaping (S.Element) -> A?) -> (S) -> [A] {
  return { xs in
    xs.compactMap(f)
  }
}

// MARK: - Functor

extension Sequence {
  @inlinable
  public static func <¢> <A>(f: (Element) -> A, xs: Self) -> [A] {
    return xs.map(f)
  }
}

@inlinable
public func map<S: Sequence, A>(_ f: @escaping (S.Element) -> A) -> (S) -> [A] {
  return { xs in
    return f <¢> xs
  }
}

// MARK: - Apply

extension Sequence {
  @inlinable
  public func apply<S: Sequence, A>(_ fs: S) -> [A] where S.Element == ((Element) -> A) {
    // return fs.flatMap(self.map) // https://bugs.swift.org/browse/SR-5251
    return fs.flatMap { f in self.map { x in f(x) } }
  }

  @inlinable
  public static func <*> <S: Sequence, A>(fs: S, xs: Self) -> [A] where S.Element == ((Element) -> A) {
    // return xs.apply(fs) // https://bugs.swift.org/browse/SR-5251
    return fs.flatMap { f in xs.map { x in f(x) } }
  }
}

@inlinable
public func apply<S: Sequence, T: Sequence, A>(_ fs: S) -> (T) -> [A] where S.Element == ((T.Element) -> A) {
  return { xs in
    // fs <*> xs // https://bugs.swift.org/browse/SR-5251
    fs.flatMap { f in xs.map { x in f(x) } }
  }
}

// MARK: - Bind/Monad

@inlinable
public func flatMap<S: Sequence, A>(_ f: @escaping (S.Element) -> [A]) -> (S) -> [A] {
  return { xs in
    xs.flatMap(f)
  }
}

// MARK: - Monoid

extension Sequence where Element: Monoid {
  @inlinable
  public func concat() -> Element {
    return Prelude.concat(self)
  }
}

@inlinable
public func concat<S: Sequence>(_ xs: S) -> S.Element where S.Element: Monoid {
  return xs.reduce(.empty, <>)
}

// MARK: - Foldable/Sequence

extension Sequence {
  @inlinable
  public func foldMap<M: Monoid>(_ f: @escaping (Element) -> M) -> M {
    return self.reduce(M.empty) { m, x in m <> f(x) }
  }
}

@inlinable
public func foldMap<S: Sequence, M: Monoid>(_ f: @escaping (S.Element) -> M) -> (S) -> M {
  return { xs in
    xs.foldMap(f)
  }
}

// MARK: - Point-free Standard Library

@inlinable
public func contains<S: Sequence>(_ x: S.Element) -> (S) -> Bool where S.Element: Equatable {
  return { xs in
    xs.contains(x)
  }
}

@inlinable
public func contains<S: Sequence>(where p: @escaping (S.Element) -> Bool) -> (S) -> Bool {
  return { xs in
    xs.contains(where: p)
  }
}

@inlinable
public func filter<S: Sequence>(_ p: @escaping (S.Element) -> Bool) -> (S) -> [S.Element] {
  return { xs in
    xs.filter(p)
  }
}

@inlinable
public func flatMap<S: Sequence, T: Sequence>(_ f: @escaping (S.Element) -> T) -> (S) -> [T.Element] {
  return { xs in
    xs.flatMap(f)
  }
}

@inlinable
public func forEach<S: Sequence>(_ f: @escaping (S.Element) -> ()) -> (S) -> () {
  return { xs in
    xs.forEach(f)
  }
}

@inlinable
public func map<A, S: Sequence>(_ f: @escaping (S.Element) -> A) -> (S) -> [A] {
  return { xs in
    xs.map(f)
  }
}

@inlinable
public func reduce<A, S: Sequence>(_ f: @escaping (A, S.Element) -> A) -> (A) -> (S) -> A {
  return { a in
    { xs in
      xs.reduce(a, f)
    }
  }
}

@inlinable
public func sorted<S: Sequence>(_ xs: S) -> [S.Element] where S.Element: Comparable {
  return xs.sorted()
}

@inlinable
public func sorted<S: Sequence>(
  by f: @escaping (S.Element, S.Element) -> Bool
) -> (S) -> [S.Element] {
  return { xs in
    xs.sorted(by: f)
  }
}

@inlinable
public func zipWith<S: Sequence, T: Sequence, A>(
  _ f: @escaping (S.Element, T.Element) -> A
) -> (S) -> (T) -> [A] {
  return { xs in
    return { ys in
      return zip(xs, ys).map { f($0.0, $0.1) }
    }
  }
}

@inlinable
public func intersperse<A>(_ a: A) -> ([A]) -> [A] {
  return { xs in
    var result = [A]()
    for x in xs.dropLast() {
      result.append(x)
      result.append(a)
    }
    xs.last.do { result.append($0) }
    return result
  }
}
