import Dispatch
import Foundation
import Prelude

/// A monad transformer (like `ExceptT`) for `IO` and `Either`.
public struct EitherIO<E, A> {
  public let run: IO<Either<E, A>>
  
  public init(run: IO<Either<E, A>>) {
    self.run = run
  }

  @inlinable
  public func `catch`(
    _ f: @escaping (E) -> EitherIO
  ) -> EitherIO {
    return catchE(self, f)
  }

  @inlinable
  public func mapExcept<F, B>(
    _ f: @escaping (Either<E, A>) -> Either<F, B>
  ) -> EitherIO<F, B> {
    return .init(
      run: self.run.map(f)
    )
  }

  @inlinable
  public func withExcept<F>(
    _ f: @escaping (E) -> F
  ) -> EitherIO<F, A> {
    return self.bimap(f, id)
  }
}

@inlinable
public func lift<E, A>(
  _ x: Either<E, A>
) -> EitherIO<E, A> {
  return EitherIO.init <<< pure <| x
}

@inlinable
public func lift<E, A>(
  _ x: IO<A>
) -> EitherIO<E, A> {
  return EitherIO.init <<< map(Either.right) <| x
}

@inlinable
public func throwE<E, A>(
  _ x: E
) -> EitherIO<E, A> {
  return lift(.left(x))
}

@inlinable
public func catchE<E, A>(
  _ x: EitherIO<E, A>,
  _ f: @escaping (E) -> EitherIO<E, A>
) -> EitherIO<E, A> {
  return .init(
    run: x.run.flatMap(either(^\.run <<< f, pure <<< Either.right))
  )
}

@inlinable
public func mapExcept<E, F, A, B>(
  _ f: @escaping (Either<E, A>) -> Either<F, B>
) -> (EitherIO<E, A>) -> EitherIO<F, B> {
  return { $0.mapExcept(f) }
}

@inlinable
public func withExcept<E, F, A>(
  _ f: @escaping (E) -> F
) -> (EitherIO<E, A>) -> EitherIO<F, A> {
  return { $0.withExcept(f) }
}

extension EitherIO where E == Error {
  @inlinable
  public static func wrap(
    _ f: @escaping () throws -> A
  ) -> EitherIO {
    return EitherIO.init <<< pure <| Either.wrap(f)
  }

  @inlinable
  public init(_ f: @escaping () async throws -> A) {
    self.init(
      run: IO {
        do {
          return try await .right(f())
        } catch {
          return .left(error)
        }
      }
    )
  }

  @inlinable
  public func performAsync() async throws -> A {
    try await self.run.performAsync().unwrap()
  }
}

extension EitherIO where E: Error {
  @inlinable
  public func performAsync() async throws -> A {
    try await self.run.performAsync().unwrap()
  }
}

extension EitherIO {
  @inlinable
  public func retry(maxRetries: Int) -> EitherIO {
    return retry(
      maxRetries: maxRetries,
      backoff: const(.seconds(0))
    )
  }

  @inlinable
  public func retry(
    maxRetries: Int,
    backoff: @escaping (Int) -> DispatchTimeInterval
  ) -> EitherIO {
    return self.retry(
      maxRetries: maxRetries,
      attempts: 1,
      backoff: backoff
    )
  }

  @usableFromInline
  internal func retry(
    maxRetries: Int,
    attempts: Int,
    backoff: @escaping (Int) -> DispatchTimeInterval
  ) -> EitherIO {
    guard attempts < maxRetries else { return self }
    return self <|> .init(
      run: self
        .retry(
          maxRetries: maxRetries,
          attempts: attempts + 1,
          backoff: backoff
        )
        .run
        .delay(backoff(attempts))
    )
  }

  @inlinable
  public func delay(_ interval: DispatchTimeInterval) -> EitherIO {
    return .init(run: self.run.delay(interval))
  }

  @inlinable
  public func delay(_ interval: TimeInterval) -> EitherIO {
    return .init(run: self.run.delay(interval))
  }
}

// MARK: - Functor

extension EitherIO {
  @inlinable
  public func map<B>(
    _ f: @escaping (A) -> B
  ) -> EitherIO<E, B> {
    return .init(
      run: self.run.map { $0.map(f) }
    )
  }

  @inlinable
  public static func <¢> <B>(
    f: @escaping (A) -> B,
    x: EitherIO
  ) -> EitherIO<E, B> {
    return x.map(f)
  }
}

@inlinable
public func map<E, A, B>(
  _ f: @escaping (A) -> B
) -> (EitherIO<E, A>) -> EitherIO<E, B> {
  return { f <¢> $0 }
}

// MARK: - Bifunctor

extension EitherIO {
  @inlinable
  public func bimap<F, B>(
    _ f: @escaping (E) -> F,
    _ g: @escaping (A) -> B
  ) -> EitherIO<F, B> {
    return .init(run: self.run.map { $0.bimap(f, g) })
  }
}

@inlinable
public func bimap<E, F, A, B>(
  _ f: @escaping (E) -> F,
  _ g: @escaping (A) -> B
) -> (EitherIO<E, A>) -> EitherIO<F, B> {
  return { $0.bimap(f, g) }
}

// MARK: - Apply

extension EitherIO {
  @inlinable
  public func apply<B>(
    _ f: EitherIO<E, (A) -> B>
  ) -> EitherIO<E, B> {
    return .init(run: curry(<*>) <¢> f.run <*> self.run)
  }

  @inlinable
  public static func <*> <B>(
    f: EitherIO<E, (A) -> B>,
    x: EitherIO
  ) -> EitherIO<E, B> {
    return x.apply(f)
  }
}

@inlinable
public func apply<E, A, B>(
  _ f: EitherIO<E, (A) -> B>
) -> (EitherIO<E, A>) -> EitherIO<E, B> {
  return { f <*> $0 }
}

// MARK: - Applicative

@inlinable
public func pure<E, A>(_ x: (A)) -> EitherIO<E, A> {
  return EitherIO.init <<< pure <<< pure <| x
}

// MARK: - Traversable

/// Sequences an array of `EitherIO`'s by first sequencing the `IO` values, and then sequencing the `Either`
/// values.
@inlinable
public func sequence<S, E, A>(
  _ xs: S
) -> EitherIO<E, [A]>
where S: Sequence, S.Element == EitherIO<E, A> {
  return EitherIO(run: sequence(xs.map(^\.run)).map(sequence))
}

// MARK: - Alt

extension EitherIO: Alt {
  @inlinable
  public static func <|> (
    lhs: EitherIO, 
    rhs: @autoclosure @escaping () -> EitherIO
    ) -> EitherIO {
    return .init(
      run: IO {
        switch await lhs.run.performAsync() {
        case .left:
          return await rhs().run.performAsync()
        case let .right(a):
          return .right(a)
        }
      }
    )
  }
}

// MARK: - Bind/Monad

extension EitherIO {
  @inlinable
  public func flatMap<B>(
    _ f: @escaping (A) -> EitherIO<E, B>
  ) -> EitherIO<E, B> {
    return .init(
      run: self.run.flatMap(either(pure <<< Either.left, ^\.run <<< f))
    )
  }
}

@inlinable
public func flatMap<E, A, B>(
  _ f: @escaping (A) -> EitherIO<E, B>
) -> (EitherIO<E, A>) -> EitherIO<E, B> {
  return { $0.flatMap(f) }
}

@inlinable
public func >=> <E, A, B, C>(
  f: @escaping (A) -> EitherIO<E, B>,
  g: @escaping (B) -> EitherIO<E, C>
) -> (A) -> EitherIO<E, C> {
  return f >>> flatMap(g)
}
