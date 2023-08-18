import Foundation

public typealias SyncFuncEndoOf<T> = SyncFunc<T, T>

public typealias SyncFuncOf<F: FunctionSignatureProtocol> = SyncFunc<
  F.Input,
  F.Output
>

public struct SyncFunc<Input, Output>: SyncFunction {
  public var call: SyncSignature

  public init(_ call: @escaping (Input) -> Output) {
    self.call = call
  }

  public func callAsFunction(_ input: Input) -> Output {
    self.call(input)
  }
}

// MARK: Type erasure

extension Function {
  @inlinable
  public func eraseToSyncFuncWithCompletion(
    priority: TaskPriority? = .none
  ) -> SyncFunc<Input, (@escaping (Output) -> Void) -> Void> {
    return .init { input in
      return { handler in
        callAsFunction(input, priority: priority, completion: handler)
      }
    }
  }
}

extension SyncFunction {
  @inlinable
  public func eraseToSyncFunc() -> SyncFunc<Input, Output> {
    return .init(callAsFunction)
  }
}

extension Function {
  @inlinable
  public func _eraseToBlockingSyncFunc(
    priority: TaskPriority? = .none
  ) -> SyncFunc<Input, Output> {
    return SyncFunc { input in
      let semaphore = DispatchSemaphore(value: 1)
      var result: Output!
      callAsFunction(input, priority: priority) { output in
        result = output
        semaphore.signal()
      }
      semaphore.wait()
      return result
    }
  }
}
