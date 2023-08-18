public typealias AsyncFunctionEndoOf<T> = AsyncFunction<T, T>

public typealias AsyncFunctionOf<F: FunctionSignatureProtocol> = AsyncFunction<
  F.Input,
  F.Output
>

public protocol AsyncFunction<Input, Output>: Function {
  init(_ call: @escaping AsyncSignature)
}

// MARK: Inits

extension AsyncFunction {
  public typealias NonConcurrentCompletionHandler = (@escaping (Output) -> Void) -> Void
  public typealias NonConcurrentSignature = SyncFunctionSignature<
    Input,
    NonConcurrentCompletionHandler
  >

  @inlinable
  public init(_ call: @escaping SyncFunctionSignature<Input, Output>) {
    self.init { call($0) }
  }

  @inlinable
  public init(checked call: @escaping NonConcurrentSignature) {
    self.init { input in
      await withCheckedContinuation { continuation in
        call(input)(continuation.resume)
      }
    }
  }

  @inlinable
  public init(unsafe call: @escaping NonConcurrentSignature) {
    self.init { input in
      await withUnsafeContinuation { continuation in
        call(input)(continuation.resume)
      }
    }
  }
}

extension AsyncFunction where Input == Void {
  @inlinable
  public init(checked call: @escaping NonConcurrentCompletionHandler) {
    self.init(checked: { _ in call })
  }

  @inlinable
  public init(unsafe call: @escaping NonConcurrentCompletionHandler) {
    self.init(unsafe: { _ in call })
  }
}

extension AsyncFunction where Input == Unit {
  @inlinable
  public init(checked call: @escaping NonConcurrentCompletionHandler) {
    self.init(checked: { _ in call })
  }

  @inlinable
  public init(unsafe call: @escaping NonConcurrentCompletionHandler) {
    self.init(unsafe: { _ in call })
  }
}

// MARK: Type erasure

extension AsyncFunction {
  @inlinable
  public func eraseToAsyncFunction() -> some AsyncFunction<Input, Output> { self }
}

// MARK: Calls

extension AsyncFunction {
  @inlinable
  public func _asyncCall(_ input: Input) async -> Output {
    await callAsFunction(input)
  }
}

extension AsyncFunction where Input == Void {
  @inlinable
  public func callAsFunction() async -> Output {
    return await callAsFunction(())
  }
}

extension AsyncFunction where Input == Unit {
  @inlinable
  public func callAsFunction() async -> Output {
    return await callAsFunction(Prelude.unit)
  }
}
