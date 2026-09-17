//
//  NotificationView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct NotificationView: View {
    
    @EnvironmentObject var store: ShopStore
    
    var body: some View {
        
        NavigationStack {
            
            if store.notifications.isEmpty {
                
                ContentUnavailableView(
                    "No Notifications",
                    systemImage: "bell"
                )
                
            } else {
                
                List {
                    
                    ForEach(
                        store.notifications
                    ) { notification in
                        
                        HStack(
                            alignment: .top,
                            spacing: 15
                        ) {
                            
                            Image(
                                systemName: "bell.fill"
                            )
                            .foregroundStyle(.black)
                            
                            VStack(
                                alignment: .leading,
                                spacing: 5
                            ) {
                                
                                Text(notification.title)
                                    .font(.headline)
                                
                                Text(notification.message)
                                    .font(.subheadline)
                                
                                Text(
                                    notification.date.formatted(
                                        date: .abbreviated,
                                        time: .shortened
                                    )
                                )
                                .font(.caption)
                                .foregroundStyle(.gray)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .navigationTitle("Notifications")
    }
}
