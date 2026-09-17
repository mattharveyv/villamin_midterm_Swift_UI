//
//  CartView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct CartView: View {
    
    @EnvironmentObject var store: ShopStore
    
    @State private var showOrderSuccess = false
    @State private var showCheckoutSheet = false
    @State private var selectedPayment = "Cash on Delivery"
    let paymentMethods = ["GCash", "Cash on Delivery", "Bank Payment"]
    
    var body: some View {
        
        NavigationStack {
            
            if store.cart.isEmpty {
                
                ContentUnavailableView(
                    "Your Cart Is Empty",
                    systemImage: "cart",
                    description: Text(
                        "Add some clothes to your cart."
                    )
                )
                
            } else {
                
                VStack {
                    
                    List {
                        
                        ForEach(store.cart) { item in
                            
                            HStack(spacing: 15) {
                                
                                ZStack {
                                    
                                    RoundedRectangle(
                                        cornerRadius: 10
                                    )
                                    .fill(.gray.opacity(0.1))
                                    
                                    Image(systemName: "tshirt.fill")
                                        .foregroundStyle(.gray)
                                }
                                .frame(
                                    width: 65,
                                    height: 65
                                )
                                
                                VStack(
                                    alignment: .leading,
                                    spacing: 5
                                ) {
                                    
                                    Text(item.product.name)
                                        .font(.headline)
                                    
                                    Text("Size: \(item.size)")
                                        .font(.caption)
                                    
                                    Text(
                                        "₱\(item.product.price, specifier: "%.2f")"
                                    )
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 5) {
                                    
                                    Button {
                                        store.increaseQuantity(
                                            item: item
                                        )
                                    } label: {
                                        Image(
                                            systemName:
                                                "plus.circle"
                                        )
                                    }
                                    
                                    Text("\(item.quantity)")
                                    
                                    Button {
                                        store.decreaseQuantity(
                                            item: item
                                        )
                                    } label: {
                                        Image(
                                            systemName:
                                                "minus.circle"
                                        )
                                    }
                                }
                            }
                        }
                        .onDelete { indexSet in
                            
                            for index in indexSet {
                                store.removeFromCart(
                                    item: store.cart[index]
                                )
                            }
                        }
                    }
                    
                    VStack(spacing: 15) {
                        
                        HStack {
                            
                            Text("Total")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text(
                                "₱\(store.cartTotal, specifier: "%.2f")"
                            )
                            .font(.title3.bold())
                        }
                        
                        Button {
                            
                            showCheckoutSheet = true
                            
                        } label: {
                            
                            Text("Place Order")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.black)
                                .foregroundStyle(.white)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 12
                                    )
                                )
                        }
                    }
                    .padding()
                    .background(.white)
                }
            }
        }
        .sheet(isPresented: $showCheckoutSheet) {
            NavigationStack {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Checkout")
                            .font(.title.bold())
                        HStack {
                            Text("Order Total")
                            Spacer()
                            Text("₱\(store.cartTotal, specifier: "%.2f")")
                                .font(.headline)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Payment Method").font(.headline)
                        Picker("Payment Method", selection: $selectedPayment) {
                            ForEach(paymentMethods, id: \.self) { method in
                                Text(method)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))

                    Spacer()

                    Button {
                        store.placeOrder(paymentMethod: selectedPayment)
                        showCheckoutSheet = false
                        showOrderSuccess = true
                    } label: {
                        Text("Confirm and Place Order")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundStyle(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Button("Cancel") { showCheckoutSheet = false }
                        .foregroundStyle(.secondary)
                }
                .padding()
                .navigationTitle("Review & Pay")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .navigationTitle("Cart")
        .alert(
            "Order Placed!",
            isPresented: $showOrderSuccess
        ) {
            Button("OK") { }
        } message: {
            Text(
                "Your order has been sent to the seller."
            )
        }
    }
}

