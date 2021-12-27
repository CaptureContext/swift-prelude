extension Bool {
  public func and(_ value: Bool) -> Bool {
    return self && value
  }
}

public func and(_ values: Bool...) -> Bool {
  return and(values)
}

public func and<C: Collection>(
  _ values: C
) -> Bool where C.Element == Bool {
  return values.allSatisfy { $0 }
}
