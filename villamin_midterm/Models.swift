//
//  Models.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import Foundation
import SwiftUI

struct UserAccount: Identifiable {
    let id = UUID()
    var name: String
    var email: String
    var password: String
    var isAdmin: Bool
}

struct ClothingItem: Identifiable {
    let id = UUID()
    var name: String
    var price: Double
    var category: String
    var categoryId: UUID? = nil
    var description: String
    var imageName: String
    var stock: Int
    var imageData: Data? = nil
}

struct CartItem: Identifiable {
    let id = UUID()
    var product: ClothingItem
    var quantity: Int
    var size: String
}

struct Order: Identifiable {
    let id = UUID()
    var customerName: String
    var items: [CartItem]
    var total: Double
    var paymentMethod: String = "Cash on Delivery"
    var status: String
    var date: Date
}

struct ShopNotification: Identifiable {
    let id = UUID()
    var title: String
    var message: String
    var date: Date
}
