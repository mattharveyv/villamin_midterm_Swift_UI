//
//  AdminSettingsView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct AdminSettingsView: View {
    
    @EnvironmentObject var store: ShopStore
    @State private var announcementText = ""
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section("Send Announcement") {
                    TextField("Announcement...", text: $announcementText)
                    Button("Send") {
                        if !announcementText.isEmpty {
                            store.sendAnnouncement(announcementText)
                            announcementText = ""
                        }
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(7)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Section("Administrator") {
                    
                    HStack(spacing: 15) {
                        
                        Image(
                            systemName:
                                "person.badge.key.fill"
                        )
                        .font(.system(size: 45))
                        
                        VStack(
                            alignment: .leading
                        ) {
                            
                            Text("Store Administrator")
                                .font(.headline)
                            
                            Text(
                                store.currentUser?.email
                                ?? ""
                            )
                            .font(.caption)
                            .foregroundStyle(.gray)
                        }
                    }
                }
                
                Section("Store Information") {
                    
                    LabeledContent(
                        "Products",
                        value:
                            "\(store.products.count)"
                    )
                    
                    LabeledContent(
                        "Orders",
                        value:
                            "\(store.orders.count)"
                    )
                }
                
                Section {
                    
                    Button(
                        "Log Out",
                        role: .destructive
                    ) {
                        store.logout()
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

