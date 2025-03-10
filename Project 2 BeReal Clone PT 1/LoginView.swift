//
//  LoginView.swift
//  Project 2 BeReal Clone PT 1
//
//  Created by Courtney Mahugu on 3/10/25.
//

import Foundation
import SwiftUI
import ParseSwift

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

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
                logInUser()
            }) {
                Text("Login")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    func logInUser() {
            // Attempt to log in using ParseSwift's user authentication
            // Use the `logIn` method for authentication
            User.login(username: email, password: password) { result in
                switch result {
                case .success:
                    print("User logged in successfully")
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
}

