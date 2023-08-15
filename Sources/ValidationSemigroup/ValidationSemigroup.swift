import Prelude

public enum Validation<E, A> {
  case valid(A)
  case invalid(E)
}

extension Validation {
  @inlinable
  public func validate<B>(_ e2b: (E) -> B, _ a2b: (A) -> B) -> B {
    switch self {
    case let .valid(a):
      return a2b(a)
    case let .invalid(e):
      return e2b(e)
    }
  }
  
  public var isValid: Bool {
    return validate(const(false), const(true))
  }
}

@inlinable
public func validate<A, B, C>(_ a2c: @escaping (A) -> C) -> (@escaping (B) -> C) -> (Validation<A, B>) -> C {
  return { b2c in
    { ab in
      ab.validate(a2c, b2c)
    }
  }
}

// MARK: - Functor

extension Validation {
  @inlinable
  public func map<B>(_ a2b: (A) -> B) -> Validation<E, B> {
    switch self {
    case let .valid(a):
      return .valid(a2b(a))
    case let .invalid(e):
      return .invalid(e)
    }
  }
  
  @inlinable
  public static func <¢> <B>(a2b: (A) -> B, a: Validation) -> Validation<E, B> {
    return a.map(a2b)
  }
}

@inlinable
public func map<A, B, C>(
  _ b2c: @escaping (B) -> C
) -> (Validation<A, B>) -> Validation<A, C> {
  return { ab in
    b2c <¢> ab
  }
}

// MARK: - Bifunctor

extension Validation {
  @inlinable
  public func bimap<B, C>(_ e2b: (E) -> B, _ a2c: (A) -> C) -> Validation<B, C> {
    switch self {
    case let .valid(a):
      return .valid(a2c(a))
    case let .invalid(e):
      return .invalid(e2b(e))
    }
  }
}

@inlinable
public func bimap<A, B, C, D>(
  _ a2c: @escaping (A) -> C
) -> (@escaping (B) -> D) -> (Validation<A, B>) -> Validation<C, D> {
  return { b2d in
    { ab in
      ab.bimap(a2c, b2d)
    }
  }
}

// MARK: - Apply

extension Validation where E: Semigroup {
  @inlinable
  public func apply<B>(_ a2b: Validation<E, (A) -> B>) -> Validation<E, B> {
    switch (a2b, self) {
    case let (.valid(f), _):
      return self.map(f)
    case let (.invalid(e), .valid):
      return .invalid(e)
    case let (.invalid(e1), .invalid(e2)):
      return .invalid(e1 <> e2)
    }
  }
  
  @inlinable
  public static func <*> <B>(a2b: Validation<E, (A) -> B>, a: Validation) -> Validation<E, B> {
    return a.apply(a2b)
  }
}

@inlinable
public func apply<A: Semigroup, B, C>(
  _ b2c: Validation<A, (B) -> C>
) -> (Validation<A, B>) -> Validation<A, C> {
  return { ab in
    b2c <*> ab
  }
}

// MARK: - Applicative

@inlinable
public func pure<E, A>(_ a: A) -> Validation<E, A> {
  return .valid(a)
}

// MARK: - Eq/Equatable

extension Validation: Equatable where E: Equatable, A: Equatable {
  @inlinable
  public static func == (lhs: Validation, rhs: Validation) -> Bool {
    switch (lhs, rhs) {
    case let (.invalid(e1), .invalid(e2)):
      return e1 == e2
    case let (.valid(a1), .valid(a2)):
      return a1 == a2
    default:
      return false
    }
  }
}

// MARK: - Ord/Comparable

extension Validation: Comparable where E: Comparable, A: Comparable {
  @inlinable
  public static func < (lhs: Validation, rhs: Validation) -> Bool {
    switch (lhs, rhs) {
    case let (.invalid(e1), .invalid(e2)):
      return e1 < e2
    case let (.valid(a1), .valid(a2)):
      return a1 < a2
    case (.invalid, .valid):
      return true
    case (.valid, .invalid):
      return false
    }
  }
}

// MARK: - Semigroup

extension Validation: Semigroup where E: Semigroup, A: Semigroup {
  @inlinable
  public static func <> (lhs: Validation, rhs: Validation) -> Validation {
    return curry(<>) <¢> lhs <*> rhs
  }
}
