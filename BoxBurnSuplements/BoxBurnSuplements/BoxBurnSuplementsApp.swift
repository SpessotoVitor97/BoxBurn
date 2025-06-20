//
//  BoxBurnSuplementsApp.swift
//  BoxBurnSuplements
//
//  Created by Vitor Spessoto on 19/06/25.
//

import SwiftUI
import SwiftData

@main
struct BoxBurnSuplementsApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(
                for: Supplement.self, CartItem.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
