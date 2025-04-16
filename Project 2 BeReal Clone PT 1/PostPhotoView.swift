//
//  PostPhotoView.swift
//  Project 2 BeReal Clone PT 1
//
//  Created by Courtney Mahugu on 3/10/25.
//

import Foundation
import SwiftUI
import UIKit
import ParseSwift

struct PostPhotoView: View {
    @State private var selectedImage: UIImage? // The image picked by the user
    @State private var isImagePickerPresented = false // To toggle image picker visibility
    @State private var errorMessage = ""
    @State private var caption = ""
    @Environment(\.dismiss) var dismiss // To go back to FeedView

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
                        isImagePickerPresented.toggle()
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
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(image: $selectedImage)
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
        post.save { result in
            switch result {
            case .success:
                print("Photo uploaded successfully")
                dismiss()
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}
