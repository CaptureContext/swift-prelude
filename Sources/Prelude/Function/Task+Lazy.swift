extension Task where Success == Void, Failure == Never {
  @inlinable
  @discardableResult
  public static func `lazy`<Input, Output>(
    priority: TaskPriority? = .none,
    _ asyncCall: @escaping (Input) async -> Output
  ) -> (Input) -> (@escaping (Output) -> Void) -> Task {
    return { input in
      return { handler in
        Task(priority: priority) { await handler <<< asyncCall <| input }
      }
    }
  }
}
