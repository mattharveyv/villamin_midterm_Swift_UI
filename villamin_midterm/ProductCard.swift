//
//  ProductCard.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct ProductCard: View {
    
    let product: ClothingItem
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(.gray.opacity(0.12))
                
                if let data = product.imageData,
                   let uiImage = UIImage(data: data) {
                    
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                    
                } else if !product.imageName.isEmpty {
                    
                    Image(product.imageName)
                        .resizable()
                        .scaledToFit()
                    
                } else {
                    
                    Image(systemName: "tshirt.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.gray)
                }
            }
            .frame(height: 160)
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .clipShape(
                RoundedRectangle(cornerRadius: 15)
            )
            
            Text(product.name)
                .font(.headline)
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(product.category)
                .font(.caption)
                .foregroundStyle(.gray)
            
            Text(
                "₱\(product.price, specifier: "%.2f")"
            )
            .font(.headline.bold())
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(white: 0.12).opacity(0.9))
                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
        )
    }
}
