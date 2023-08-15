extension Bool {
  @inlinable
  public func and(_ value: Bool) -> Bool {
    return self && value
  }
}

@inlinable
public func and(_ values: Bool...) -> Bool {
  return and(values)
}

@inlinable
public func and<C: Collection>(
  _ values: C
) -> Bool where C.Element == Bool {
  return values.allSatisfy { $0 }
}
