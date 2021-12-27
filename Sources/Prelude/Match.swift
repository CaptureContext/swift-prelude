@inlinable
public func match<Pattern, Value>(
  _ pattern: Pattern,
  matcher: (Pattern) -> Value
) -> Value {
  match(pattern)(matcher)
}

@inlinable
public func match<Pattern, Value>(
  _ pattern: Pattern
) -> ((Pattern) -> Value) -> Value {
  return { matcher in
    return matcher(pattern)
  }
}
