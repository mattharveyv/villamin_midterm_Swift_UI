//
//  villamin_midtermApp.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

@main
struct villamin_midtermApp: App {
    
    @StateObject private var store = ShopStore()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .preferredColorScheme(store.useDarkMode ? .dark : .light)
        }
    }
}
