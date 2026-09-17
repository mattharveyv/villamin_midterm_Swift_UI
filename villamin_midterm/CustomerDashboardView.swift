//
//  CustomerDashboardView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct CustomerDashboardView: View {
    
    @EnvironmentObject var store: ShopStore
    
    var body: some View {
        
        TabView {
            
            HomeView()
                .tabItem {
                    Label(
                        "Home",
                        systemImage: "house.fill"
                    )
                }
            
            CartView()
                .tabItem {
                    Label(
                        "Cart",
                        systemImage: "cart.fill"
                    )
                }
                .badge(store.cart.count)
            
            NotificationView()
                .tabItem {
                    Label(
                        "Notifications",
                        systemImage: "bell.fill"
                    )
                }
                .badge(store.notifications.count)
            
            ProfileView()
                .tabItem {
                    Label(
                        "Profile",
                        systemImage: "person.fill"
                    )
                }
        }
        .tint(.black)
    }
}
