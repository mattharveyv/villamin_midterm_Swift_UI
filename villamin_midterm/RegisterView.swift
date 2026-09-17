//
//  RegisterView.swift
//  villamin_midterm
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var store: ShopStore
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    @State private var showError = false
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section("Create Account") {
                    
                    TextField(
                        "Full Name",
                        text: $name
                    )
                    
                    TextField(
                        "Email",
                        text: $email
                    )
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    
                    SecureField(
                        "Password",
                        text: $password
                    )
                }
                
                Section {
                    
                    Button("Create Account") {
                        
                        if name.isEmpty ||
                            email.isEmpty ||
                            password.isEmpty {
                            
                            showError = true
                            return
                        }
                        
                        let success = store.register(
                            name: name,
                            email: email,
                            password: password
                        )
                        
                        if success {
                            dismiss()
                        } else {
                            showError = true
                        }
                    }
                }
            }
            .navigationTitle("Register")
            .alert(
                "Registration Failed",
                isPresented: $showError
            ) {
                Button("OK") { }
            } message: {
                Text(
                    "Please fill in all fields or use another email."
                )
            }
        }
    }
}
