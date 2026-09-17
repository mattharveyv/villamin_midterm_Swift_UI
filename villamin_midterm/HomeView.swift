//
//  HomeView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var store: ShopStore
    
    @State private var searchText = ""
    @State private var selectedCategoryId: UUID? = nil
    
    var filteredProducts: [ClothingItem] {
        let byCategory: [ClothingItem] = {
            if let id = selectedCategoryId {
                return store.products.filter { $0.categoryId == id || store.categoryId(forName: $0.category) == id }
            } else {
                return store.products
            }
        }()
        if searchText.isEmpty { return byCategory }
        return byCategory.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                store.theme.background.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome back!")
                                .font(.subheadline)
                                .foregroundStyle(store.theme.secondaryText)
                            Text(
                                store.currentUser?.name ?? "Customer"
                            )
                            .font(.title.bold())
                            .foregroundStyle(store.theme.primaryText)
                        }
                        Text("Discover Your Style")
                            .font(.largeTitle.bold())
                            .foregroundStyle(store.theme.primaryText)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                CategoryChip(title: "All Products", isSelected: selectedCategoryId == nil) { selectedCategoryId = nil }
                                ForEach(store.categories) { category in
                                    CategoryChip(title: category.name, isSelected: selectedCategoryId == category.id) { selectedCategoryId = category.id }
                                }
                            }
                        }
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 16
                        ) {
                            ForEach(filteredProducts) { product in
                                NavigationLink {
                                    ProductDetailView(product: product)
                                } label: {
                                    ProductCard(product: product)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        if filteredProducts.isEmpty {
                            ContentUnavailableView("No products available in this category.", systemImage: "tshirt", description: Text("Try another category or check back later."))
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Shop")
            .searchable(
                text: $searchText,
                prompt: "Search clothes"
            )
            .tint(store.theme.accent)
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(isSelected ? Color.black : Color.gray.opacity(0.2))
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
