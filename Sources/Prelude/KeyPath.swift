@inlinable
public func get<Root, Value>(
  _ keyPath: KeyPath<Root, Value>
) -> (Root) -> Value {
  return { root in
    root[keyPath: keyPath]
  }
}

@inlinable
public func over<Root, Value>(
  _ keyPath: WritableKeyPath<Root, Value>
) -> (@escaping (Value) -> Value) -> (Root) -> Root {
    return { over in
      { root in
        var copy = root
        copy[keyPath: keyPath] = over(copy[keyPath: keyPath])
        return copy
      }
    }
}

@inlinable
public func set<Root, Value>(
  _ keyPath: WritableKeyPath<Root, Value>
) -> (Value) -> (Root) -> Root {
  return over(keyPath) <<< const
}

prefix operator ^

extension KeyPath {
  @inlinable
  public static prefix func ^ (rhs: KeyPath) -> (Root) -> Value {
    return get(rhs)
  }
}

@inlinable
public func < <Root, Value: Comparable>(
  lhs: KeyPath<Root, Value>,
  rhs: Value
) -> (Root) -> Bool {
  return { $0[keyPath: lhs] < rhs }
}

@inlinable
public func > <Root, Value: Comparable>(
  lhs: KeyPath<Root, Value>,
  rhs: Value
) -> (Root) -> Bool {
  return { $0[keyPath: lhs] > rhs }
}

@inlinable
public func <= <Root, Value: Comparable>(
  lhs: KeyPath<Root, Value>,
  rhs: Value
) -> (Root) -> Bool {
  return { $0[keyPath: lhs] < rhs }
}

@inlinable
public func >= <Root, Value: Comparable>(
  lhs: KeyPath<Root, Value>,
  rhs: Value
) -> (Root) -> Bool {
  return { $0[keyPath: lhs] > rhs }
}

@inlinable
public func == <Root, Value: Equatable>(
  lhs: KeyPath<Root, Value>,
  rhs: Value
) -> (Root) -> Bool {
  return { $0[keyPath: lhs] == rhs }
}
