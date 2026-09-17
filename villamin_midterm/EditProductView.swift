//
//  EditProductView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct EditProductView: View {
    
    @EnvironmentObject var store: ShopStore
    @Environment(\.dismiss) var dismiss
    
    let product: ClothingItem
    
    @State private var price: String
    @State private var stock: String
    
    init(product: ClothingItem) {
        
        self.product = product
        
        _price = State(
            initialValue: String(
                format: "%.2f",
                product.price
            )
        )
        
        _stock = State(
            initialValue: "\(product.stock)"
        )
    }
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section("Product") {
                    
                    Text(product.name)
                        .font(.headline)
                    
                    Text(product.category)
                        .foregroundStyle(.gray)
                }
                
                Section("Edit Product") {
                    
                    TextField(
                        "Price",
                        text: $price
                    )
                    .keyboardType(.decimalPad)
                    
                    TextField(
                        "Stock",
                        text: $stock
                    )
                    .keyboardType(.numberPad)
                }
                
                Section {
                    
                    Button("Save Changes") {
                        
                        store.updateProduct(
                            product: product,
                            price: Double(price)
                                ?? product.price,
                            stock: Int(stock)
                                ?? product.stock
                        )
                        
                        dismiss()
                    }
                }
            }
            .navigationTitle("Edit Product")
        }
    }
}
