public protocol FunctionSignatureProtocol<Input, Output> {
  associatedtype Input
  associatedtype Output
}

public typealias SyncFunctionSignature<A, B> = (A) -> B
public typealias AsyncFunctionSignature<A, B> = (A) async -> B

public typealias SyncFunctionSignatureOf<
  F: FunctionSignatureProtocol
> = SyncFunctionSignature<
  F.Input,
  F.Output
>

public typealias AsyncFunctionSignatureOf<
  F: FunctionSignatureProtocol
> = AsyncFunctionSignature<
  F.Input,
  F.Output
>
