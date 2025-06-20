import SwiftUI

struct SupplementListView: View {
    @ObservedObject var viewModel: SupplementListViewModel
    @State private var selectedCategory: SupplementCategory = .all
    @Binding var isMenuShowing: Bool
    
    init(viewModel: SupplementListViewModel, isMenuShowing: Binding<Bool>) {
        self.viewModel = viewModel
        _isMenuShowing = isMenuShowing
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Amazon-style header
                VStack(spacing: 8) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField(NSLocalizedString("home_search_placeholder", comment: "Search supplements..."), text: $viewModel.searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(SupplementCategory.allCases, id: \.self) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: selectedCategory == category
                                ) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 16)
                .background(Color.white)
                
                // Content
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Featured Items Section
                        if selectedCategory == .all {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(NSLocalizedString("home_featured_title", comment: "Featured Supplements"))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 20)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(viewModel.filteredSupplements.prefix(5)) { supplement in
                                            FeaturedSupplementCard(supplement: supplement, viewModel: viewModel)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                        
                        // All Supplements Section
                        SupplementsSection(viewModel: viewModel, selectedCategory: selectedCategory, isMenuShowing: $isMenuShowing)
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: isMenuShowing ? HamburgerButton(isMenuShowing: $isMenuShowing) : nil)
        }
        .onAppear {
            viewModel.refreshData()
        }
    }
} 