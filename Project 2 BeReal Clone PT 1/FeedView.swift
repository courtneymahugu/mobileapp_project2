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
    @State private var showingPostPhotoView = false
    @AppStorage("isLoggedIn") var isLoggedIn = false

    var body: some View {
        NavigationView {
                    VStack {
                        if isLoading && posts.isEmpty {
                            ProgressView("Loading posts...")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if posts.isEmpty {
                            Text("No posts yet. Pull to refresh!")
                                .foregroundColor(.gray)
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            List(posts, id: \.objectId) { post in
                                VStack(alignment: .leading) {
                                    Text(post.username ?? "Anonymous")
                                        .font(.headline)

                                    if let imageFile = post.image, let urlString = imageFile.url?.absoluteString {
                                        AsyncImage(url: URL(string: urlString)) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity, maxHeight: 300)
                                    }

                                    if let caption = post.caption {
                                        Text(caption)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                            .listStyle(PlainListStyle())
                            .refreshable {
                                fetchPosts()
                            }
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("BeReal.")
                                .font(.title)
                                .fontWeight(.bold)
                        }

                        ToolbarItem(placement: .navigationBarLeading) {
                            Image(systemName: "person.2.fill")
                        }

                        ToolbarItem(placement: .navigationBarTrailing) {
                            HStack {
                                Button("Post a Photo") {
                                    showingPostPhotoView = true
                                }
                                Button("Logout") {
                                    logoutUser()
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $showingPostPhotoView) {
                        PostPhotoView()
                    }
                    .onAppear {
                        fetchPosts()
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
                    posts = postsFetched
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
        
//        let lastPost = posts.last
        let thresholdIndex = posts.index(posts.endIndex, offsetBy: -1)

        if thresholdIndex == posts.count - 1 {
            fetchPosts() // Trigger fetch for more posts when reaching the bottom
        }
    }
    
    //logs out user
    func logoutUser() {
        User.logout { result in
            switch result {
            case .success:
                print("User logged out")
                isLoggedIn = false // this hides FeedView
            case .failure(let error):
                print("Logout failed: \(error.localizedDescription)")
            }
        }
    }

}



