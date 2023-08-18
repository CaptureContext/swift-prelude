public typealias AsyncFuncEndoOf<T> = AsyncFunc<T, T>

public typealias AsyncFuncOf<F: FunctionSignatureProtocol> = AsyncFunc<
  F.Input,
  F.Output
>

public struct AsyncFunc<Input, Output>: AsyncFunction {
  public let call: AsyncSignature

  public init(_ call: @escaping (Input) async -> Output) {
    self.call = call
  }

  @inlinable
  public func callAsFunction(_ input: Input) async -> Output {
    await self.call(input)
  }
}

// MARK: Type erasure

extension Function {
  @inlinable
  public func eraseToAsyncFunc() -> AsyncFunc<Input, Output> {
    .init(callAsFunction)
  }
}

//// Have to implement in on a Func type directly due to compilation error:
//// - Member operator '>¢<' of protocol 'Function' must have at least one argument of type 'Self'
//extension AsyncFunc { // Contravariant
//  @inlinable
//  public static func >¢< <A, B, C>(f: @escaping (B) -> A, g: AsyncFunc<A, C>) -> AsyncFunc<B, C> {
//    return g.contramap(f)
//  }
//}
//
//@inlinable
//public func dimap<A, B, C, D>(
//  _ f: @escaping (A) -> B,
//  _ g: @escaping (C) -> D
//) -> (AsyncFunc<B, C>) -> AsyncFunc<A, D> {
//  return { $0.dimap(f, g) }
//}
//
//// MARK: Applicative
//
//@inlinable
//public func pure<A, B>(_ b: B) -> AsyncFunc<A, B> {
//  return .async(const(b))
//}
//
//extension AsyncFunc: Semigroup where AsyncOutput: Semigroup {}
//
//extension AsyncFunc: Monoid where AsyncOutput: Monoid {}
//
//extension AsyncFunc: NearSemiring where AsyncOutput: NearSemiring {}
//
//extension AsyncFunc: Semiring where AsyncOutput: Semiring {}
