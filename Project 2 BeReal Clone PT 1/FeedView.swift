//
//  FeedView.swift
//  Project 2 BeReal Clone PT 1
//
//  Created by Courtney Mahugu on 3/10/25.
//

import Foundation
import SwiftUI
import ParseSwift

struct FeedView: View {
    @State private var posts: [Post] = [] // An array to store posts
    @State private var isLoading = false // To track if we're loading more posts

    var body: some View {
        NavigationView {
            List(posts, id: \.objectId) { post in
                VStack(alignment: .leading) {
                    // Display username if available
                    Text(post.username ?? "Anonymous")
                        .font(.headline)

                    // Check if there is an image and display it
                    if let imageFile = post.image, let urlString = imageFile.url?.absoluteString {
                        // Fetch image asynchronously
                        AsyncImage(url: URL(string: urlString)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    } else {
                        Text("No image available")
                            .foregroundColor(.gray)
                    }

                    // Display caption if available
                    if let caption = post.caption {
                        Text(caption)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .onAppear {
                fetchPosts() // Load the first set of posts when the view appears
            }
            .refreshable {
                fetchPosts() // Reload posts when pulled to refresh
            }
            .onAppear {
                loadMorePostsIfNeeded()
            }
        }
    }

    // Fetch posts from Parse
    func fetchPosts() {
        guard !isLoading else { return } // Avoid fetching if already loading
        isLoading = true
        
        Post.query()
            .limit(10) // Limit the number of posts fetched
            .find { result in
                switch result {
                case .success(let postsFetched):
                    posts.append(contentsOf: postsFetched)
                case .failure(let error):
                    print("Error fetching posts: \(error.localizedDescription)")
                }
                isLoading = false
            }
    }

    // Load more posts when the user scrolls to the bottom
    func loadMorePostsIfNeeded() {
        // Check if we reached the bottom of the list
        if posts.isEmpty { return } // Skip if no posts available
        
        let lastPost = posts.last
        let thresholdIndex = posts.index(posts.endIndex, offsetBy: -1)

        if thresholdIndex == posts.count - 1 {
            fetchPosts() // Trigger fetch for more posts when reaching the bottom
        }
    }
}

