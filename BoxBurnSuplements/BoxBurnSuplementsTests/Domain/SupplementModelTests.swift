import Testing
import Foundation
@testable import BoxBurnSuplements

@Test
func testSupplementInitAndEquality() {
    let id = UUID()
    let supplement1 = Supplement(id: id, name: "Test", description: "desc", price: 1.0, imageName: "img", category: "protein", isFavorite: true)
    let supplement2 = Supplement(id: id, name: "Test", description: "desc", price: 1.0, imageName: "img", category: "protein", isFavorite: true)
    #expect(supplement1 == supplement2)
    #expect(supplement1.hashValue == supplement2.hashValue)
    #expect(supplement1.name == "Test")
    #expect(supplement1.productDescription == "desc")
    #expect(supplement1.price == 1.0)
    #expect(supplement1.imageName == "img")
    #expect(supplement1.category == "protein")
    #expect(supplement1.isFavorite)
} 