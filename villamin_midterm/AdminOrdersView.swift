//
//  AdminOrdersView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct AdminOrdersView: View {
    
    @EnvironmentObject var store: ShopStore
    
    let statuses = [
        "Pending",
        "Processing",
        "Shipped",
        "Completed",
        "Cancelled"
    ]
    
    var body: some View {
        
        NavigationStack {
            
            if store.orders.isEmpty {
                
                ContentUnavailableView(
                    "No Orders",
                    systemImage: "shippingbox"
                )
                .padding()
                
            } else {
                
                List {
                    
                    ForEach(store.orders) { order in
                        
                        VStack(
                            alignment: .leading,
                            spacing: 12
                        ) {
                            
                            HStack {
                                
                                Text(
                                    "Order #\(order.id.uuidString.prefix(6))"
                                )
                                .font(.headline)
                                
                                Spacer()
                                
                                Text(order.status)
                                    .font(.caption.bold())
                            }
                            .padding(.bottom, 4)
                            
                            Text(
                                "Customer: \(order.customerName)"
                            )
                            
                            Text("Payment: \(order.paymentMethod)")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            
                            Text(
                                "Total: ₱\(order.total, specifier: "%.2f")"
                            )
                            
                            Text(
                                "\(order.items.count) item(s)"
                            )
                            .font(.caption)
                            .foregroundStyle(.gray)
                            
                            Picker(
                                "Order Status",
                                selection: Binding(
                                    get: {
                                        order.status
                                    },
                                    set: { newStatus in
                                        
                                        store.updateOrderStatus(
                                            order: order,
                                            status: newStatus
                                        )
                                    }
                                )
                            ) {
                                
                                ForEach(
                                    statuses,
                                    id: \.self
                                ) { status in
                                    
                                    Text(status)
                                        .tag(status)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(.black)
                            .font(.subheadline.bold())
                            .padding(.top, 6)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 8)
                        .listRowBackground(Color.white)
                    }
                }
                .listStyle(.plain)
            }
        }
        .background(.white)
        .navigationTitle("Orders")
    }
}
