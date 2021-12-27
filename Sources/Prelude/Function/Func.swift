import XCTestDynamicOverlay

public struct Func<Input, Output>: Function {
  public let call: (Input) -> Output

  public init(_ call: @escaping Signature) {
    self.call = call
  }
}

// Have to implement in on a Func type directly due to compilation error:
// - Member operator '>¢<' of protocol 'Function' must have at least one argument of type 'Self'
extension Func /* : Contravariant */ {
  public static func >¢< <A, B, C>(f: @escaping (B) -> A, g: Func<A, C>) -> Func<B, C> {
    return g.contramap(f)
  }
}

public func dimap<A, B, C, D>(
  _ f: @escaping (A) -> B,
  _ g: @escaping (C) -> D
) -> (Func<B, C>) -> Func<A, D> {
  return { $0.dimap(f, g) }
}

// MARK: Applicative

public func pure<A, B>(_ b: B) -> Func<A, B> {
  return .init(const(b))
}

extension Func: Semigroup where B: Semigroup {}
  
extension Func: Monoid where B: Monoid {}

extension Func: NearSemiring where B: NearSemiring {}

extension Func: Semiring where B: Semiring {}
