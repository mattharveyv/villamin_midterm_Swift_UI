//
//  AboutView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct AboutView: View {
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Image(systemName: "tshirt.fill")
                .font(.system(size: 70))
            
            Text("CLOTHIFY")
                .font(.largeTitle.bold())
            
            Text("Online Clothing Shop")
                .foregroundStyle(.gray)
            
            Text(
                "Clothify is an online clothing shop application built using SwiftUI."
            )
            .multilineTextAlignment(.center)
            .padding()
        }
        .padding()
        .navigationTitle("About")
    }
}
