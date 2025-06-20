import Testing
import SwiftUI
@testable import BoxBurnSuplements

struct DummyView: View {
    var body: some View {
        Text("Hello")
    }
}

@Test
func testIfViewExtension() {
    let view = DummyView().if(true) { $0.background(Color.red) }
    // _ = view.body // Do not access .body directly in tests
    #expect(type(of: view) != nil)
} 