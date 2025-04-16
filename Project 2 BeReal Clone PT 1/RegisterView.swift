//
//  RegisterView.swift
//  Project 2 BeReal Clone PT 1
//
//  Created by Courtney Mahugu on 3/10/25.
//

import SwiftUI
import ParseSwift

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                registerUser()
            }) {
                Text("Register")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Button("Already have an account? Log in") {
                            dismiss()
                        }
                        .foregroundColor(.blue)
                        .padding(.top, 10)
        }
        .padding()
    }

    func registerUser() {
        // Create a new user with ParseSwift
        var user = User()
        user.username = email
        user.password = password
        user.save { result in
            switch result {
            case .success:
                print("User registered successfully")
                dismiss()
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
    
}

#Preview {
    RegisterView()
}
