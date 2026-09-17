//
//  RootView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var store: ShopStore
    
    var body: some View {
        
        Group {
            
            if let user = store.currentUser {
                
                if user.isAdmin {
                    AdminDashboardView()
                } else {
                    CustomerDashboardView()
                }
                
            } else {
                LoginView()
            }
        }
    }
}
