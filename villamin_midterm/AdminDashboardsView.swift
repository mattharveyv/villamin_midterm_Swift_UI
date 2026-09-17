//
//  AdminDashboardsView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct AdminDashboardView: View {
    
    var body: some View {
        
        TabView {
            
            AdminProductsView()
                .tabItem {
                    Label(
                        "Products",
                        systemImage: "tshirt.fill"
                    )
                }
            
            AdminOrdersView()
                .tabItem {
                    Label(
                        "Orders",
                        systemImage: "shippingbox.fill"
                    )
                }
            
            AdminSettingsView()
                .tabItem {
                    Label(
                        "Settings",
                        systemImage: "gearshape.fill"
                    )
                }
        }
        .tint(.black)
    }
}
