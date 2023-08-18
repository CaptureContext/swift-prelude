import Prelude

public enum Either<L, R> {
  case left(L)
  case right(R)
}

extension Either {
  @inlinable
  public func either<A>(
    _ l2a: (L) throws -> A,
    _ r2a: (R) -> A
  ) rethrows -> A {
    switch self {
    case let .left(l):
      return try l2a(l)
    case let .right(r):
      return r2a(r)
    }
  }

  @inlinable
  public var left: L? {
    return either(Optional.some, const(.none))
  }

  @inlinable
  public var right: R? {
    return either(const(.none), Optional.some)
  }

  @inlinable
  public var isLeft: Bool {
    return either(const(true), const(false))
  }

  @inlinable
  public var isRight: Bool {
    return either(const(false), const(true))
  }
}

@inlinable
public func either<A, B, C>(
  _ a2c: @escaping (A) -> C,
  _ b2c: @escaping (B) -> C
) -> (Either<A, B>) -> C {
  return { ab in
    ab.either(a2c, b2c)
  }
}

@inlinable
public func lefts<S: Sequence, L, R>(
  _ xs: S
) -> [L] where S.Element == Either<L, R> {
  return xs |> mapOptional { $0.left }
}

@inlinable
public func rights<S: Sequence, L, R>(
  _ xs: S
) -> [R] where S.Element == Either<L, R> {
  return xs |> mapOptional { $0.right }
}

@inlinable
public func note<L, R>(
  _ default: L
) -> (R?) -> Either<L, R> {
  return optional(.left(`default`)) <| Either.right
}

@inlinable
public func hush<L, R>(
  _ lr: Either<L, R>
) -> R? {
  return lr.either(const(.none), R?.some)
}

extension Either where L == Error {
  @inlinable
  public static func wrap<A>(
    _ f: @escaping (A) throws -> R
  ) -> (A) -> Either {
    return { a in
      do {
        return .right(try f(a))
      } catch let error {
        return .left(error)
      }
    }
  }

  @inlinable
  public static func wrap(
    _ f: @escaping () throws -> R
  ) -> Either {
    do {
      return .right(try f())
    } catch let error {
      return .left(error)
    }
  }

  @inlinable
  public func unwrap() throws -> R {
    return try either({ throw $0 }, id)
  }
}

extension Either where L: Error {
  @inlinable
  public func unwrap() throws -> R {
    return try either({ throw $0 }, id)
  }
}

@inlinable
public func unwrap<R>(
  _ either: Either<Error, R>
) throws -> R {
  return try either.unwrap()
}

@inlinable
public func unwrap<L: Error, R>(
  _ either: Either<L, R>
) throws -> R {
  return try either.unwrap()
}

// MARK: - Functor

extension Either {
  @inlinable
  public func map<A>(
    _ r2a: (R) -> A
  ) -> Either<L, A> {
    switch self {
    case let .left(l):
      return .left(l)
    case let .right(r):
      return .right(r2a(r))
    }
  }

  @inlinable
  public static func <¢> <A>(
    r2a: (R) -> A,
    lr: Either
  ) -> Either<L, A> {
    return lr.map(r2a)
  }
}

@inlinable
public func map<A, B, C>(
  _ b2c: @escaping (B) -> C
) -> (Either<A, B>) -> Either<A, C> {
  return { ab in
    b2c <¢> ab
  }
}

// MARK: - Bifunctor

extension Either {
  @inlinable
  public func bimap<A, B>(
    _ l2a: (L) -> A,
    _ r2b: (R) -> B
  ) -> Either<A, B> {
    switch self {
    case let .left(l):
      return .left(l2a(l))
    case let .right(r):
      return .right(r2b(r))
    }
  }
}

@inlinable
public func bimap<A, B, C, D>(
  _ a2b: @escaping (A) -> B,
  _ c2d: @escaping (C) -> D
) -> (Either<A, C>) -> Either<B, D> {
    return { ac in
      ac.bimap(a2b, c2d)
    }
}

// MARK: - Apply

extension Either {
  @inlinable
  public func apply<A>(
    _ r2a: Either<L, (R) -> A>
  ) -> Either<L, A> {
    return r2a.flatMap(self.map)
  }

  @inlinable
  public static func <*> <A>(
    r2a: Either<L, (R) -> A>,
    lr: Either<L, R>
  ) -> Either<L, A> {
    return lr.apply(r2a)
  }
}

@inlinable
public func apply<A, B, C>(
  _ b2c: Either<A, (B) -> C>
) -> (Either<A, B>) -> Either<A, C> {
  return { ab in
    b2c <*> ab
  }
}

// MARK: - Applicative

@inlinable
public func pure<L, R>(_ r: R) -> Either<L, R> {
  return .right(r)
}

// MARK: - Traversable

@inlinable
public func traverse<S, E, A, B>(
  _ f: @escaping (A) -> Either<E, B>
) -> (S) -> Either<E, [B]>
where S: Sequence, S.Element == A {
    return { xs in
      var ys: [B] = []
      for x in xs {
        let y = f(x)
        switch y {
        case let .left(e):
          return .left(e)
        case let .right(y):
          ys.append(y)
        }
      }
      return .right(ys)
    }
}

/// Returns first `left` value in array of `Either`'s, or an array of `right` values if there are no `left`s.
@inlinable
public func sequence<E, A>(_ xs: [Either<E, A>]) -> Either<E, [A]> {
  return xs |> traverse(id)
}

// MARK: - Alt

extension Either: Alt {
  @inlinable
  public static func <|> (lhs: Either, rhs: @autoclosure @escaping () -> Either) -> Either {
    switch lhs {
    case .left:
      return rhs()
    case .right:
      return lhs
    }
  }
}

// MARK: - Bind/Monad

extension Either {
  @inlinable
  public func flatMap<A>(
    _ r2a: (R) -> Either<L, A>
  ) -> Either<L, A> {
    return either(Either<L, A>.left, r2a)
  }
}

@inlinable
public func flatMap <L, R, A>(
  _ r2a: @escaping (R) -> Either<L, A>
) -> (Either<L, R>) -> Either<L, A> {
  return { lr in
    lr.flatMap(r2a)
  }
}

@inlinable
public func >=> <E, A, B, C>(
  f: @escaping (A) -> Either<E, B>,
  g: @escaping (B) -> Either<E, C>
) -> (A) -> Either<E, C> {
  return f >>> flatMap(g)
}

// MARK: - Eq/Equatable

extension Either: Equatable where L: Equatable, R: Equatable {
  @inlinable
  public static func == (lhs: Either, rhs: Either) -> Bool {
    switch (lhs, rhs) {
    case let (.left(lhs), .left(rhs)):
      return lhs == rhs
    case let (.right(lhs), .right(rhs)):
      return lhs == rhs
    default:
      return false
    }
  }
}

// MARK: - Ord/Comparable

extension Either: Comparable where L: Comparable, R: Comparable {
  @inlinable
  public static func < (lhs: Either, rhs: Either) -> Bool {
    switch (lhs, rhs) {
    case let (.left(lhs), .left(rhs)):
      return lhs < rhs
    case let (.right(lhs), .right(rhs)):
      return lhs < rhs
    case (.left, .right):
      return true
    case (.right, .left):
      return false
    }
  }
}

// MARK: - Foldable/Sequence

extension Either where R: Sequence {
  @inlinable
  public func reduce<A>(
    _ a: A,
    _ f: @escaping (A, R.Element) -> A
  ) -> A {
    return self.map(Prelude.reduce(f) <| a).either(const(a), id)
  }
}

@inlinable
public func foldMap<S: Sequence, M: Monoid, L>(
  _ f: @escaping (S.Element) -> M
) -> (Either<L, S>) -> M {
  return { xs in
    xs.reduce(.empty) { accum, x in accum <> f(x) }
  }
}

// MARK: - Semigroup

extension Either: Semigroup where R: Semigroup {
  @inlinable
  public static func <> (lhs: Either, rhs: Either) -> Either {
    return curry(<>) <¢> lhs <*> rhs
  }
}

// MARK: - NearSemiring

extension Either: NearSemiring where R: NearSemiring {
  @inlinable
  public static func + (lhs: Either, rhs: Either) -> Either {
    return curry(+) <¢> lhs <*> rhs
  }

  @inlinable
  public static func * (lhs: Either, rhs: Either) -> Either {
    return curry(*) <¢> lhs <*> rhs
  }

  @inlinable
  public static var zero: Either {
    return .right(R.zero)
  }
}

// MARK: - Semiring

extension Either: Semiring where R: Semiring {
  @inlinable
  public static var one: Either {
    return .right(R.one)
  }
}

// MARK: - Codable

extension Either: Decodable where L: Decodable, R: Decodable {
  @inlinable
  public init(from decoder: Decoder) throws {
    do {
      self = try .right(.init(from: decoder))
    } catch {
      self = try .left(.init(from: decoder))
    }
  }
}

extension Either: Encodable where L: Encodable, R: Encodable {
  @inlinable
  public func encode(to encoder: Encoder) throws {
    switch self {
    case let .left(l):
      try l.encode(to: encoder)
    case let .right(r):
      try r.encode(to: encoder)
    }
  }
}
