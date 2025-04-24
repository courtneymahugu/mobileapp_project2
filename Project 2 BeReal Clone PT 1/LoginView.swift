//
//  LoginView.swift
//  Project 3 BeReal Clone PT 2
//
//  Created by Courtney Mahugu on 3/10/25.
//

import Foundation
import SwiftUI
import ParseSwift
import UserNotifications

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isLoggedIn = false
    @State private var isRegistering = false

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
            Button("Don't have an account? Sign Up") {
                isRegistering = true
            }
            .foregroundColor(.blue)
            .padding(.top, 10)
        }
        .padding()
        .fullScreenCover(isPresented: $isLoggedIn) {
                    FeedView() // Show this after login
                }
        .fullScreenCover(isPresented: $isRegistering) {
            RegisterView()
        }
    }

    func logInUser() {
            // Attempt to log in using ParseSwift's user authentication
            // Use the `logIn` method for authentication
            User.login(username: email, password: password) { result in
                switch result {
                case .success:
                    print("User logged in successfully")
                    isLoggedIn = true
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                        if granted {
                            print("Notifications permission granted.")
                            schedulePostReminder()
                        } else if let error = error {
                            print("Permission error: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    
    func schedulePostReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Time to BeReal!"
        content.body = "Don’t forget to post your daily update."
        content.sound = UNNotificationSound.default

        // Every hour (3600 seconds)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)

        let request = UNNotificationRequest(identifier: "BeRealReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification scheduling error: \(error.localizedDescription)")
            }
        }
    }
}

