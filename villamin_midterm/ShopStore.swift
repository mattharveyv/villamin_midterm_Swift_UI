//
//  ShopStore.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI
import Combine

// MARK: - Theme

struct AppTheme {
    var background: Color
    var primaryText: Color
    var secondaryText: Color
    var cardBackground: Color
    var accent: Color
    var accentBeige: Color

    static let dark = AppTheme(
        background: Color.black,
        primaryText: Color.white,
        secondaryText: Color.gray,
        cardBackground: Color(white: 0.12),
        accent: Color(white: 0.85),
        accentBeige: Color(red: 0.82, green: 0.74, blue: 0.62)
    )

    static let light = AppTheme(
        background: Color(red: 0.97, green: 0.97, blue: 0.95),
        primaryText: Color.black,
        secondaryText: Color.gray,
        cardBackground: Color(red: 0.93, green: 0.93, blue: 0.90),
        accent: Color(red: 0.35, green: 0.35, blue: 0.35),
        accentBeige: Color(red: 0.78, green: 0.70, blue: 0.58)
    )
}

// MARK: - Payment & Order Status

enum PaymentMethod: String, CaseIterable, Identifiable, Codable {
    case gcash = "GCash"
    case cashOnDelivery = "Cash on Delivery"
    case bank = "Bank Payment"
    var id: String { rawValue }
}

enum OrderStatus: String, CaseIterable, Identifiable, Codable {
    case processing = "Processing"
    case cancelled = "Cancelled"
    case delivered = "Delivered"
    case completed = "Completed"
    var id: String { rawValue }
}

class ShopStore: ObservableObject {

    // MARK: - Category Model
    struct Category: Identifiable, Codable, Equatable {
        var id: UUID = UUID()
        var name: String
        var createdAt: Date = Date()
        var updatedAt: Date = Date()
    }

    // Global minimalist theme (black/gray/white)
    @Published var theme: AppTheme = .dark
    @Published var useDarkMode: Bool = true
    func toggleThemeMode() {
        useDarkMode.toggle()
        theme = useDarkMode ? .dark : .light
    }

    // Selected payment method for checkout UI
    @Published var selectedPaymentMethod: PaymentMethod = .cashOnDelivery

    @Published var users: [UserAccount] = [
        UserAccount(
            name: "Admin",
            email: "admin@clothify.com",
            password: "admin123",
            isAdmin: true
        )
    ]

    @Published var products: [ClothingItem] = []

    @Published var cart: [CartItem] = []

    @Published var orders: [Order] = []

    // Dynamic categories managed by admin
    @Published var categories: [Category] = []

    @Published var notifications: [ShopNotification] = [
        ShopNotification(
            title: "Welcome to Clothify!",
            message: "Start shopping for your favorite clothes.",
            date: Date()
        )
    ]

    @Published var currentUser: UserAccount?

    init() {
        // Seed example categories if none exist
        if categories.isEmpty {
            let names = ["T-Shirts","Polo Shirts","Hoodies","Pants","Shorts","Jackets"]
            self.categories = names.map { Category(name: $0) }
        }
        // Link legacy products to category ids when names match
        for i in products.indices {
            if products[i].categoryId == nil, !products[i].category.isEmpty {
                products[i].categoryId = categoryId(forName: products[i].category)
            }
        }
    }

    // MARK: - Login

    func login(email: String, password: String) -> Bool {

        if let user = users.first(where: {
            $0.email.lowercased() == email.lowercased()
            && $0.password == password
        }) {

            currentUser = user
            return true
        }

        return false
    }

    // MARK: - Register

    func register(
        name: String,
        email: String,
        password: String
    ) -> Bool {

        if users.contains(where: {
            $0.email.lowercased() == email.lowercased()
        }) {
            return false
        }

        let newUser = UserAccount(
            name: name,
            email: email,
            password: password,
            isAdmin: false
        )

        users.append(newUser)

        return true
    }

    // MARK: - Categories
    func categoryName(for id: UUID?) -> String {
        guard let id else { return "" }
        return categories.first(where: { $0.id == id })?.name ?? ""
    }

    func categoryId(forName name: String) -> UUID? {
        categories.first { $0.name.caseInsensitiveCompare(name) == .orderedSame }?.id
    }

    func addCategory(name: String) {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        // prevent duplicates by case-insensitive compare
        if categories.contains(where: { $0.name.caseInsensitiveCompare(name) == .orderedSame }) { return }
        let new = Category(name: name)
        categories.append(new)
    }

    func updateCategory(category: Category, newName: String) {
        guard let index = categories.firstIndex(of: category) else { return }
        var updated = categories[index]
        updated.name = newName
        updated.updatedAt = Date()
        categories[index] = updated
        // Optionally update product legacy string names that matched this category
        for i in products.indices {
            if products[i].category.caseInsensitiveCompare(category.name) == .orderedSame {
                products[i].category = newName
            }
        }
    }

    func deleteCategory(_ category: Category) {
        categories.removeAll { $0.id == category.id }
        // For products referencing this category by id, clear the id but keep legacy string
        for i in products.indices {
            if products[i].categoryId == category.id { products[i].categoryId = nil }
        }
    }

    // MARK: - Logout

    func logout() {
        currentUser = nil
        cart.removeAll()
    }

    // MARK: - Cart

    func addToCart(
        product: ClothingItem,
        size: String,
        quantity: Int
    ) {

        if let index = cart.firstIndex(where: {
            $0.product.id == product.id &&
            $0.size == size
        }) {

            cart[index].quantity += quantity

        } else {

            let item = CartItem(
                product: product,
                quantity: quantity,
                size: size
            )

            cart.append(item)
        }
    }

    func removeFromCart(item: CartItem) {

        cart.removeAll {
            $0.id == item.id
        }
    }

    func increaseQuantity(item: CartItem) {

        if let index = cart.firstIndex(where: {
            $0.id == item.id
        }) {

            cart[index].quantity += 1
        }
    }

    func decreaseQuantity(item: CartItem) {

        if let index = cart.firstIndex(where: {
            $0.id == item.id
        }) {

            if cart[index].quantity > 1 {
                cart[index].quantity -= 1
            }
        }
    }

    var cartTotal: Double {

        cart.reduce(0) {
            $0 + ($1.product.price * Double($1.quantity))
        }
    }

    // MARK: - Place Order

    func placeOrder(paymentMethod: PaymentMethod? = nil) {

        guard let user = currentUser else {
            return
        }

        guard !cart.isEmpty else {
            return
        }

        let chosenMethod = paymentMethod ?? selectedPaymentMethod

        let order = Order(
            customerName: user.name,
            items: cart,
            total: cartTotal,
            paymentMethod: chosenMethod.rawValue,
            status: OrderStatus.processing.rawValue,
            date: Date()
        )

        orders.append(order)

        notifications.insert(
            ShopNotification(
                title: "Order Placed",
                message: "Your order has been successfully placed.",
                date: Date()
            ),
            at: 0
        )

        cart.removeAll()
    }
    /// Backwards-compatible overload accepting String payment method
    func placeOrder(paymentMethod: String) {
        let mapped = PaymentMethod.allCases.first { $0.rawValue.lowercased() == paymentMethod.lowercased() } ?? selectedPaymentMethod
        placeOrder(paymentMethod: mapped)
    }

    // MARK: - Admin

    func addProduct(
        name: String,
        price: Double,
        category: String,
        description: String,
        imageName: String,
        imageData: Data? = nil,
        stock: Int
    ) {

        let product = ClothingItem(
            name: name,
            price: price,
            category: category,
            description: description,
            imageName: imageName,
            stock: stock,
            imageData: imageData
        )

        products.append(product)
    }
    
    func addProduct(
        name: String,
        price: Double,
        categoryId: UUID?,
        description: String,
        imageName: String,
        imageData: Data? = nil,
        stock: Int
    ) {
        let readableCategory = categoryName(for: categoryId)
        var product = ClothingItem(
            name: name,
            price: price,
            category: readableCategory.isEmpty ? "" : readableCategory,
            description: description,
            imageName: imageName,
            stock: stock,
            imageData: imageData
        )
        product.categoryId = categoryId
        products.append(product)
    }
    
    func deleteProduct(_ product: ClothingItem) {
        products.removeAll { $0.id == product.id }
    }

    func updateProduct(
        product: ClothingItem,
        price: Double,
        stock: Int
    ) {

        if let index = products.firstIndex(where: {
            $0.id == product.id
        }) {

            products[index].price = price
            products[index].stock = stock
        }
    }

    func updateOrderStatus(
        order: Order,
        status: OrderStatus
    ) {

        if let index = orders.firstIndex(where: {
            $0.id == order.id
        }) {

            orders[index].status = status.rawValue

            notifications.insert(
                ShopNotification(
                    title: "Order Updated",
                    message: "Your order is now \(status.rawValue).",
                    date: Date()
                ),
                at: 0
            )
        }
    }
    /// Backwards-compatible overload accepting String status
    func updateOrderStatus(
        order: Order,
        status: String
    ) {
        let mapped = OrderStatus.allCases.first { $0.rawValue.lowercased() == status.lowercased() } ?? .processing
        updateOrderStatus(order: order, status: mapped)
    }

    // MARK: - Admin Announcement

    func addAnnouncement(
        title: String,
        message: String
    ) {
        let announcement = ShopNotification(
            title: title,
            message: message,
            date: Date()
        )
        notifications.insert(announcement, at: 0)
    }
    
    func sendAnnouncement(_ message: String) {
        notifications.insert(
            ShopNotification(
                title: "Announcement",
                message: message,
                date: Date()
            ), at: 0)
    }
    
    // MARK: - Admin Helpers
    func postAdminAnnouncement(_ message: String) {
        notifications.insert(
            ShopNotification(
                title: "Announcement",
                message: message,
                date: Date()
            ), at: 0)
    }
}

