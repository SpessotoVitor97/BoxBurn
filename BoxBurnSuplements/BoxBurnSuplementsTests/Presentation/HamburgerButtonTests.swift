import Testing
import SwiftUI
@testable import BoxBurnSuplements

@Test
func testHamburgerButtonRenders() {
    @State var isMenuShowing = false
    let button = HamburgerButton(isMenuShowing: $isMenuShowing)
    _ = button.body
} 