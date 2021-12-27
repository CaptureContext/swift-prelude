import XCTest
import Prelude

class MatchTests: XCTestCase {
  func testDefault() {
    enum A { case a, b, c }
    XCTAssertEqual(
      0,
      match(A.a) {
        switch $0 {
        case .a: return 0
        default: return 1
        }
      } 
    )
  }
}
