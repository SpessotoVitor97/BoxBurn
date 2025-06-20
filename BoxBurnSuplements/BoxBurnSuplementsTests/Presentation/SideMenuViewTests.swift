import Testing
import SwiftUI
@testable import BoxBurnSuplements

@Test
func testSideMenuViewRenders() {
    @State var isShowing = false
    let view = SideMenuView(isShowing: $isShowing, onSelect: { _ in })
    _ = view.body
} 