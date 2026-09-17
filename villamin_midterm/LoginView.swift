//
//  LoginView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var store: ShopStore
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var showRegister = false
    @State private var showError = false
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 25) {
                
                Spacer()
                
                Image(systemName: "tshirt.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.black)
                
                Text("CLOTHIFY")
                    .font(.largeTitle.bold())
                
                Text("Online Clothing Shop")
                    .foregroundStyle(.gray)
                
                VStack(spacing: 15) {
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                }
                
                Button {
                    
                    let success = store.login(
                        email: email,
                        password: password
                    )
                    
                    if !success {
                        showError = true
                    }
                    
                } label: {
                    
                    Text("Login")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.black)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )
                }
                
                Button("Create Account") {
                    showRegister = true
                }
                
                Spacer()
            }
            .padding(25)
            .sheet(isPresented: $showRegister) {
                RegisterView()
                    .environmentObject(store)
            }
            .alert(
                "Login Failed",
                isPresented: $showError
            ) {
                Button("OK") { }
            } message: {
                Text("Incorrect email or password.")
            }
        }
    }
}
