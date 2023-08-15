public enum Comparator {
  case lt
  case gt
  case eq
}

extension Comparator: Equatable {
  @inlinable
  public static func == (lhs: Comparator, rhs: Comparator) -> Bool {
    switch (lhs, rhs) {
    case (.lt, .lt), (.gt, .gt), (.eq, eq):
      return true
    default:
      return false
    }
  }
}

extension Comparator: Comparable {
  @inlinable
  public static func < (lhs: Comparator, rhs: Comparator) -> Bool {
    switch (lhs, rhs) {
    case (.lt, .lt):
      return false
    case (.lt, _), (.eq, .gt):
      return true
    default:
      return false
    }
  }
}

extension Comparator: Semigroup {
  @inlinable
  public static func <> (lhs: Comparator, rhs: Comparator) -> Comparator {
    switch (lhs, rhs) {
    case (.lt, _):
      return .lt
    case (.gt, _):
      return .gt
    case let (.eq, r):
      return r
    }
  }
}

@inlinable
public func inverted(_ ordering: Comparator) -> Comparator {
  switch ordering {
  case .lt:
    return .gt
  case .gt:
    return .lt
  case .eq:
    return .eq
  }
}
