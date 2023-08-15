@inlinable
public func drop<C: Collection>(
  while p: @escaping (C.Element) -> Bool
) -> (C) -> C.SubSequence {
  return { xs in
    xs.drop(while: p)
  }
}

@inlinable
public func dropFirst<C: Collection>(
  _ xs: C
) -> C.SubSequence {
  return xs.dropFirst()
}

@inlinable
public func dropFirst<C: Collection>(
  _ n: Int
) -> (C) -> C.SubSequence {
  return { xs in
    xs.dropFirst(n)
  }
}

@inlinable
public func dropLast<C: Collection>(
  _ xs: C
) -> C.SubSequence {
  return xs.dropLast()
}

@inlinable
public func dropLast<C: Collection>(
  _ n: Int
) -> (C) -> C.SubSequence {
  return { xs in
    xs.dropLast(n)
  }
}

@inlinable
public func prefix<C: Collection>(
  _ n: Int
) -> (C) -> C.SubSequence {
  return { xs in
    xs.prefix(n)
  }
}

@inlinable
public func prefix<C: Collection>(
  while p: @escaping (C.Element) -> Bool
) -> (C) -> C.SubSequence {
  return { xs in
    xs.prefix(while: p)
  }
}

@inlinable
public func suffix<C: Collection>(
  _ n: Int
) -> (C) -> C.SubSequence {
  return { xs in
    xs.suffix(n)
  }
}

@inlinable
public func uncons<C: Collection>(
  _ xs: C
) -> (C.Element, C.SubSequence)? {
  guard let head = xs.first else { return nil }
  return (head, xs.dropFirst())
}

@inlinable
public func unsnoc<C: BidirectionalCollection>(
  _ xs: C
) -> (C.SubSequence, C.Element)? {
  guard let last = xs.last else { return nil }
  return (xs.dropLast(), last)
}
