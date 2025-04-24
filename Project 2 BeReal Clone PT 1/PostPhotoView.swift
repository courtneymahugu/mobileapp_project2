//
//  PostPhotoView.swift
//  Project 3 BeReal Clone PT 2
//
//  Created by Courtney Mahugu on 3/10/25.
//

import Foundation
import SwiftUI
import UIKit
import ParseSwift
import CoreLocation

struct PostPhotoView: View {
    @State private var selectedImage: UIImage? // The image picked by the user
    @State private var isImagePickerPresented = false // To toggle image picker visibility
    @State private var errorMessage = ""
    @State private var caption = ""
    @Environment(\.dismiss) var dismiss // To go back to FeedView
    @StateObject private var locationManager = LocationManager()
    @State private var showSourcePicker = false
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary



    var body: some View {
        NavigationView {
                VStack {
                    TextField("Caption", text: $caption)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    } else {
                        Text("Select a photo to upload")
                            .padding()
                    }

                    Button("Select Photo") {
//                        isImagePickerPresented.toggle()
                        showSourcePicker = true
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }

                    Spacer()
                }
                .padding()
                .navigationTitle("Post Photo")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Post") {
                            uploadPhoto()
                        }
                    }
                }
                .actionSheet(isPresented: $showSourcePicker) {
                    ActionSheet(
                        title: Text("Choose Photo Source"),
                        buttons: [
                            .default(Text("Take Photo")) {
                                imageSource = .camera
                                isImagePickerPresented = true
                            },
                            .default(Text("Choose from Library")) {
                                imageSource = .photoLibrary
                                isImagePickerPresented = true
                            },
                            .cancel()
                        ]
                    )
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(image: $selectedImage, sourceType: imageSource)
                }
            }
    }

    // Function to upload the selected photo to Parse
    func uploadPhoto() {
        guard let image = selectedImage else {
            errorMessage = "Please select a photo to upload."
            return
        }

        let imageData = image.jpegData(compressionQuality: 0.8)!
        let imageFile = ParseFile(name: "image.jpg", data: imageData)

        var post = Post()
        post.image = imageFile
        post.caption = caption
        post.username = User.current?.username

        if let location = locationManager.lastLocation {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let placemark = placemarks?.first {
                    let city = placemark.locality ?? ""
                    let state = placemark.administrativeArea ?? ""
                    let country = placemark.country ?? ""
                    post.locationName = [city, state, country].filter { !$0.isEmpty }.joined(separator: ", ")
                }

                post.latitude = location.coordinate.latitude
                post.longitude = location.coordinate.longitude

                savePost(post)
            }
        } else {
            // No location? Just save the post as-is
            savePost(post)
        }
    }
    
    func savePost(_ post: Post) {
        post.save { result in
            switch result {
            case .success:
                print("Photo uploaded successfully")
                if var user = User.current {
                    user.lastPostedAt = Date()
                    user.save { _ in }
                }
                dismiss()
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}
