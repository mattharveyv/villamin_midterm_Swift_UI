//
//  ProfileView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var store: ShopStore
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section("My Profile") {
                    
                    HStack(spacing: 15) {
                        
                        Image(
                            systemName:
                                "person.circle.fill"
                        )
                        .font(.system(size: 60))
                        
                        VStack(
                            alignment: .leading
                        ) {
                            
                            Text(
                                store.currentUser?.name
                                ?? "User"
                            )
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
                
                Section("Account") {
                    
                    NavigationLink("My Orders") {
                        MyOrdersView()
                    }
                    
                    NavigationLink("About Clothify") {
                        AboutView()
                    }
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
            .navigationTitle("Profile")
        }
    }
}
