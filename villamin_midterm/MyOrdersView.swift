//
//  MyOrdersView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct MyOrdersView: View {
    
    @EnvironmentObject var store: ShopStore
    
    var myOrders: [Order] {
        
        guard let name = store.currentUser?.name else {
            return []
        }
        
        return store.orders.filter {
            $0.customerName == name
        }
    }
    
    var body: some View {
        
        Group {
            
            if myOrders.isEmpty {
                
                ContentUnavailableView(
                    "No Orders",
                    systemImage: "shippingbox"
                )
                
            } else {
                
                List {
                    
                    ForEach(myOrders) { order in
                        
                        VStack(
                            alignment: .leading,
                            spacing: 8
                        ) {
                            
                            HStack {
                                
                                Text(
                                    "Order #\(order.id.uuidString.prefix(6))"
                                )
                                .font(.headline)
                                
                                Spacer()
                                
                                Text(order.status)
                                    .font(.caption.bold())
                                    .padding(
                                        .horizontal,
                                        10
                                    )
                                    .padding(
                                        .vertical,
                                        5
                                    )
                                    .background(
                                        .gray.opacity(0.15)
                                    )
                                    .clipShape(
                                        Capsule()
                                    )
                            }
                            
                            Text(
                                "Total: ₱\(order.total, specifier: "%.2f")"
                            )
                            
                            Text(
                                "\(order.items.count) item(s)"
                            )
                            .font(.caption)
                            .foregroundStyle(.gray)
                            
                            Text(
                                order.date.formatted(
                                    date: .abbreviated,
                                    time: .shortened
                                )
                            )
                            .font(.caption)
                            .foregroundStyle(.gray)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .navigationTitle("My Orders")
    }
}
