//
//  AdminProductsView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct AdminProductsView: View {
    
    @EnvironmentObject var store: ShopStore
    
    @State private var showAddProduct = false
    @State private var selectedProduct: ClothingItem?
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                store.theme.background.ignoresSafeArea()
                List {
                    ForEach(store.products) { product in
                        HStack(spacing: 15) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.12))
                                if let data = product.imageData, let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                } else if !product.imageName.isEmpty {
                                    Image(product.imageName)
                                        .resizable()
                                        .scaledToFit()
                                } else {
                                    Image(systemName: "tshirt.fill")
                                        .font(.system(size: 28))
                                        .foregroundStyle(.gray)
                                }
                            }
                            .frame(width: 80, height: 80)
                            VStack(
                                alignment: .leading,
                                spacing: 5
                            ) {
                                Text(product.name)
                                    .font(.headline)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text(product.category)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                Text("₱\(product.price, specifier: "%.2f")")
                                    .font(.subheadline.bold())
                                Text("Stock: \(product.stock)")
                                    .font(.caption)
                            }
                            Spacer()
                            HStack(spacing: 8) {
                                Button("Edit") { selectedProduct = product }
                                Button(role: .destructive) { store.deleteProduct(product) } label: { Text("Delete") }
                            }
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(white: 0.12).opacity(0.9))
                        )
                    }
                    .onDelete(perform: delete)
                    if store.products.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "shippingbox")
                                .font(.largeTitle)
                                .foregroundStyle(.gray)
                            Text("No products yet")
                                .foregroundStyle(.gray)
                            Text("Tap + to add your first product.")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .navigationTitle("Products")
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        store.toggleThemeMode()
                    } label: {
                        Image(systemName: store.useDarkMode ? "moon.fill" : "sun.max.fill")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AdminCategoriesView().environmentObject(store)
                    } label: {
                        Image(systemName: "tag")
                    }
                }
                
                ToolbarItem(
                    placement: .topBarTrailing
                ) {
                    
                    Button {
                        showAddProduct = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(
                isPresented: $showAddProduct
            ) {
                AddProductView()
                    .environmentObject(store)
            }
            .sheet(
                item: $selectedProduct
            ) { product in
                
                EditProductView(
                    product: product
                )
                .environmentObject(store)
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets { store.deleteProduct(store.products[index]) }
    }
}

