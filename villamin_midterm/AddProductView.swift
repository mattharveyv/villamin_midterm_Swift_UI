//
//  AddProductView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI
import PhotosUI

struct AddProductView: View {
    
    @EnvironmentObject var store: ShopStore
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var price = ""
    @State private var description = ""
    @State private var stock = ""
    
    @State private var selectedCategoryId: UUID? = nil
    @State private var showAddCategory = false
    @State private var newCategoryName = ""
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section("Select Category") {
                    Picker("Category", selection: $selectedCategoryId) {
                        ForEach(store.categories) { category in
                            Text(category.name).tag(Optional(category.id))
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Product Information") {
                    
                    TextField(
                        "Product Name",
                        text: $name
                    )
                    
                    TextField(
                        "Price",
                        text: $price
                    )
                    .keyboardType(.decimalPad)
                    
                    TextField(
                        "Description",
                        text: $description,
                        axis: .vertical
                    )
                    .lineLimit(3...6)
                    
                    TextField(
                        "Stock",
                        text: $stock
                    )
                    .keyboardType(.numberPad)
                }
                
                Section("Product Image") {
                    
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images
                    ) {
                        
                        Label(
                            "Choose Clothing Image",
                            systemImage: "photo"
                        )
                    }
                    
                    if let imageData = selectedImageData,
                       let image = UIImage(
                        data: imageData
                    ) {
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                maxHeight: 250
                            )
                    }
                }
                
                Section {
                    
                    Button("Add Product") {
                        
                        store.addProduct(
                            name: name,
                            price: Double(price) ?? 0,
                            categoryId: selectedCategoryId,
                            description: description,
                            imageName: "",
                            imageData: selectedImageData,
                            stock: Int(stock) ?? 0
                        )
                        
                        dismiss()
                    }
                    .disabled(
                        name.isEmpty ||
                        price.isEmpty ||
                        selectedCategoryId == nil
                    )
                }
            }
            .navigationTitle("Add Product")
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddCategory = true
                    } label: {
                        Image(systemName: "plus.square.on.square")
                    }
                    .accessibilityLabel("New Category")
                }
            }
            .task(id: selectedPhoto) {
                
                if let data =
                    try? await selectedPhoto?
                        .loadTransferable(
                            type: Data.self
                        ) {
                    
                    selectedImageData = data
                }
            }
            .sheet(isPresented: $showAddCategory) {
                NavigationStack {
                    Form {
                        TextField("Category name", text: $newCategoryName)
                        Button("Save") {
                            let name = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                            if !name.isEmpty {
                                store.addCategory(name: name)
                                newCategoryName = ""
                                selectedCategoryId = store.categoryId(forName: name)
                            }
                            dismiss()
                        }
                    }
                    .navigationTitle("New Category")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Close") {
                                showAddCategory = false
                            }
                        }
                    }
                }
            }
        }
    }
}
