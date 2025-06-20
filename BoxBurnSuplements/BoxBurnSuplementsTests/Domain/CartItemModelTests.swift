import Testing
import Foundation
@testable import BoxBurnSuplements

@Test
func testCartItemInitAndEquality() {
    let id = UUID()
    let supplementId = UUID()
    let item1 = CartItem(id: id, supplementId: supplementId, quantity: 2)
    let item2 = CartItem(id: id, supplementId: supplementId, quantity: 2)
    #expect(item1 == item2)
    #expect(item1.hashValue == item2.hashValue)
} 