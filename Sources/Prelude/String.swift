@inlinable
public func replicate(_ n: Int) -> (String) -> String {
  return { str in (0..<n).map(const(str)).joined() }
}

// MARK: - Point-free Standard Library

@inlinable
public func hasPrefix(_ prefix: String) -> (String) -> Bool {
  return { $0.hasPrefix(prefix) }
}

@inlinable
public func hasSuffix(_ suffix: String) -> (String) -> Bool {
  return { $0.hasSuffix(suffix) }
}

@inlinable
public func lowercased(_ string: String) -> String {
  return string.lowercased()
}

@inlinable
public func uppercased(_ string: String) -> String {
  return string.uppercased()
}
