public enum Func<Input, Output>: AsyncFunction, SyncFunction {
  public typealias AsyncOutput = Output
  public typealias SyncOutput = AsyncFunctionSyncHandler<AsyncOutput>
  public typealias SyncSignature = AsyncFunctionSyncSignature<Input, AsyncOutput>
  public typealias AsyncSignature = AsyncFunctionSignature<Input, AsyncOutput>

  case sync(SyncFunc<Input, Output>)
  case async(AsyncFunc<Input, Output>)

  public init(syncCall: @escaping (Input) -> Output) {
    self = .sync(.sync(syncCall))
  }

  public init(syncCall: @escaping SyncSignature) {
    self = .async(.sync(syncCall))
  }

  public init(asyncCall: @escaping AsyncSignature) {
    self = .async(.async(asyncCall))
  }

  public var syncCall: SyncSignature { self.async.syncCall }
  public var asyncCall: AsyncSignature { self.async.asyncCall }

  @inlinable
  public var async: AsyncFunc<Input, Output> {
    switch self {
    case let .sync(function): return function.eraseToAsyncFunc()
    case let .async(function): return function
    }
  }
}
