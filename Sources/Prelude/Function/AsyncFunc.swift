public struct AsyncFunc<Input, AsyncOutput>: AsyncFunction {
  public let asyncCall: (Input) async -> AsyncOutput

  public init(asyncCall: @escaping (Input) async -> AsyncOutput) {
    self.asyncCall = asyncCall
  }
}

// Have to implement in on a Func type directly due to compilation error:
// - Member operator '>¢<' of protocol 'Function' must have at least one argument of type 'Self'
extension AsyncFunc { // Contravariant
  @inlinable
  public static func >¢< <A, B, C>(f: @escaping (B) -> A, g: AsyncFunc<A, C>) -> AsyncFunc<B, C> {
    return g.contramap(f)
  }
}

@inlinable
public func dimap<A, B, C, D>(
  _ f: @escaping (A) -> B,
  _ g: @escaping (C) -> D
) -> (AsyncFunc<B, C>) -> AsyncFunc<A, D> {
  return { $0.dimap(f, g) }
}

// MARK: Applicative

@inlinable
public func pure<A, B>(_ b: B) -> AsyncFunc<A, B> {
  return .async(const(b))
}

extension AsyncFunc: Semigroup where AsyncOutput: Semigroup {}

extension AsyncFunc: Monoid where AsyncOutput: Monoid {}

extension AsyncFunc: NearSemiring where AsyncOutput: NearSemiring {}

extension AsyncFunc: Semiring where AsyncOutput: Semiring {}
