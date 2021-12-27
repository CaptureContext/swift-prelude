import XCTestDynamicOverlay

public protocol Function {
  associatedtype Input
  associatedtype Output
  typealias A = Input
  typealias B = Output
  typealias Signature = (Input) -> Output
  var call: Signature { get }
  init(_ call: @escaping Signature)
}

extension Function where Input == Never {
  public static var absurd: Self {
    return .init(Prelude.absurd)
  }
}

extension Function {
  public static func const(_ value: Output) -> Self {
    return .init(Prelude.const(value))
  }
  
  public static func unimplemented(
    file: StaticString = #fileID,
    line: UInt = #line
  ) -> Self {
    return .init { _ in
      fatalError(
        "Call to unimplemented function declared on \(file):\(line)."
      )
    }
  }
}

extension Function {
  public func eraseToFunc() -> Func<Input, Output> {
    return Func<Input, Output>(call)
  }
}

extension Function {
  public func callAsFunction(_ input: Input) -> Output {
    return call(input)
  }
}

extension Function where Input == Void {
  public func callAsFunction() -> Output {
    return call(())
  }
}

extension Function /* : Semigroupoid */ {
  public static func >>> <G: Function>(f: Self, g: G) -> Func<A, G.B> where G.A == B {
    return .init(f.call >>> g.call)
  }
  
  public static func <<< <F: Function>(f: F, g: Self) -> Func<A, F.B> where F.A == B {
    return .init(f.call <<< g.call)
  }
}

extension Function /* : Functor */ {
  public func map<C>(_ f: @escaping (B) -> C) -> Func<A, C> {
    return .init(self.call >>> f)
  }
  
  public static func <¢> <C>(f: @escaping (B) -> C, g: Self) -> Func<A, C> {
    return g.map(f)
  }
}

public func map<A, B, C, F: Function>(_ f: @escaping (B) -> C) -> (F) -> Func<A, C>
where F.A == A, F.B == B {
  return { $0.map(f) }
}

extension Function {
  public func contramap<Z>(_ f: @escaping (Z) -> A) -> Func<Z, B> {
    return .init(f >>> self.call)
  }
}

public func contramap<A, B, C, G: Function>(_ f: @escaping (B) -> A) -> (G) -> Func<B, C>
where G.A == A, G.B == C {
  return { $0.contramap(f) }
}

extension Function /* : Profunctor */ {
  public func dimap<Z, C>(_ f: @escaping (Z) -> A, _ g: @escaping (B) -> C) -> Func<Z, C> {
    return .init(f >>> self.call >>> g)
  }
}

extension Function /* : Apply */ {
  public func apply<F: Function, G: Function, C>(_ f: F) -> Func<A, C>
  where F.A == A, F.B == G, G.A == B, G.B == C {
    return .init { a in f.call(a).call(self.call(a)) }
  }
  
  public static func <*> <F: Function, G: Function, C>(f: F, x: Self) -> Func<A, C>
  where F.A == A, F.B == G, G.A == B, G.B == C {
    return x.apply(f)
  }
}

public func apply<F: Function, G: Function, B, C>(_ f: F) -> (Func<F.A, B>) -> Func<F.A, C>
where F.B == G, G.A == B, G.B == C {
  return { $0.apply(f) }
}

// MARK: Applicative
extension Function {
  public static func pure(_ b: B) -> Self {
    return .const(b)
  }
}

extension Function /* : Monad */ {
  public func flatMap<F: Function>(_ f: @escaping (B) -> F) -> Func<A, F.B>
  where F.A == A {
    return .init { f(self.call($0)).call($0) }
  }
}

public func flatMap<F: Function, C>(_ f: @escaping (C) -> F) -> (Func<F.A, C>) -> Func<F.A, F.B> {
  return { $0.flatMap(f) }
}

extension Function where B: Semigroup {
  public static func <> (f: Self, g: Self) -> Self {
    return .init { f.call($0) <> g.call($0) }
  }
}

extension Function where B: Monoid {
  public static var empty: Self {
    return .const(B.empty)
  }
}

extension Function where B: NearSemiring {
  public static func + (f: Self, g: Self) -> Self {
    return .init { f.call($0) + g.call($0) }
  }
  
  public static func * (f: Self, g: Self) -> Self {
    return .init { f.call($0) * g.call($0) }
  }
  
  public static var zero: Self {
    return .const(B.zero)
  }
}

extension Function where B: Semiring {
  public static var one: Self {
    return .const(B.one)
  }
}
