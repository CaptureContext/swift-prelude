@inlinable
public func cast<T>(
  to type: T.Type = T.self
) -> (Any) -> T? {
  return { $0 as? T }
}

@inlinable
public func isCastable<T>(
  to type: T.Type = T.self
) -> (Any) -> Bool {
  return { $0 is T }
}
