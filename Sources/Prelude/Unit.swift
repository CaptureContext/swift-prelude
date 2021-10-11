public typealias None = Unit
public struct Unit: Codable, Equatable, Hashable {}

public let unit = Unit()

extension Unit {
  public init(from decoder: Decoder) throws { self.init() }
  public func encode(to encoder: Encoder) throws {}
}

extension Unit {
  public static func == (_: Unit, _: Unit) -> Bool {
    return true
  }
}

extension Unit: Monoid {
  public static var empty: Unit = unit
  
  public static func <> (lhs: Unit, rhs: Unit) -> Unit {
    return unit
  }
}

extension Unit: Error {}

extension Unit: ExpressibleByNilLiteral {
  public init(nilLiteral: ()) {
    self.init()
  }
}
