//
//  ProductDetailView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI
import UIKit

struct ProductDetailView: View {
    
    @EnvironmentObject var store: ShopStore
    
    let product: ClothingItem
    
    @State private var selectedSize = "M"
    @State private var quantity = 1
    @State private var addedToCart = false
    
    let sizes = ["S", "M", "L", "XL"]
    
    var body: some View {
        
        ZStack {
            store.theme.background
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.gray.opacity(0.1))
                        if let data = product.imageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .clipped()
                        } else if !product.imageName.isEmpty {
                            Image(product.imageName)
                                .resizable()
                                .scaledToFill()
                                .clipped()
                        } else {
                            Image(systemName: "tshirt.fill")
                                .font(.system(size: 100))
                                .foregroundStyle(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )
                    
                    Text(product.name)
                        .font(.title.bold())
                        .foregroundStyle(store.theme.primaryText)
                    
                    Text(
                        "₱\(product.price, specifier: "%.2f")"
                    )
                    .font(.title2.bold())
                    .foregroundStyle(store.theme.primaryText)
                    
                    Text(product.description)
                        .foregroundStyle(store.theme.secondaryText)
                    
                    Text("Select Size")
                        .font(.headline)
                        .foregroundStyle(store.theme.primaryText)
                    
                    Picker(
                        "Size",
                        selection: $selectedSize
                    ) {
                        
                        ForEach(
                            sizes,
                            id: \.self
                        ) { size in
                            
                            Text(size)
                                .tag(size)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Stepper(
                        "Quantity: \(quantity)",
                        value: $quantity,
                        in: 1...max(1, product.stock)
                    )
                    
                    Text(
                        "Available Stock: \(product.stock)"
                    )
                    .font(.caption)
                    .foregroundStyle(store.theme.secondaryText)
                    
                    Button {
                        
                        store.addToCart(
                            product: product,
                            size: selectedSize,
                            quantity: quantity
                        )
                        
                        addedToCart = true
                        
                    } label: {
                        
                        Label(
                            "Add to Cart",
                            systemImage: "cart.badge.plus"
                        )
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundStyle(.white)
                        .background(.black)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Product")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            "Added to Cart",
            isPresented: $addedToCart
        ) {
            Button("OK") { }
        }
    }
}

