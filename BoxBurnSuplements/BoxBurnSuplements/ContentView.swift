//
//  ContentView.swift
//  BoxBurnSuplements
//
//  Created by Vitor Spessoto on 19/06/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: SupplementListViewModel?
    
    var body: some View {
        Group {
            if let viewModel = viewModel {
                RootView(homeViewModel: viewModel)
            } else {
                ProgressView("Loading...")
                    .onAppear {
                        setupViewModel()
                    }
            }
        }
    }
    
    private func setupViewModel() {
        let backendService = BackendService()
        let repository = SwiftDataSupplementRepository(
            modelContext: modelContext,
            backendService: backendService
        )
        
        let fetchSupplementsUseCase = FetchSupplementsUseCase(repository: repository)
        let favoritesUseCase = FavoritesUseCase(repository: repository)
        let cartUseCase = CartUseCase(repository: repository)
        
        viewModel = SupplementListViewModel(
            fetchSupplementsUseCase: fetchSupplementsUseCase,
            favoritesUseCase: favoritesUseCase,
            cartUseCase: cartUseCase
        )
    }
}

#Preview {
    ContentView()
}
