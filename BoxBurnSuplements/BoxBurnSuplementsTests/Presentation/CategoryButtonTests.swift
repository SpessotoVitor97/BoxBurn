import Testing
import SwiftUI
@testable import BoxBurnSuplements

@Test
func testCategoryButtonRenders() {
    let button = CategoryButton(category: .protein, isSelected: true, action: {})
    _ = button.body
} 