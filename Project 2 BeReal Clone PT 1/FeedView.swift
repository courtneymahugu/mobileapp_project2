//
//  FeedView.swift
//  Project 3 BeReal Clone PT 2
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
    @State private var selectedPost: Post?
    @State private var isCommentSheetPresented = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                if let lastPosted = User.current?.lastPostedAt,
                   Date().timeIntervalSince(lastPosted) > 86400 {
                    
                    // If user hasn’t posted in last 24 hours
                    VStack {
                        Text("You must post to view others' posts.")
                            .font(.headline)
                            .padding()
                        Button("Post Now") {
                            showingPostPhotoView = true
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else {
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

                                if let createdAt = post.createdAt {
                                    Text("Posted on \(createdAt.formatted(.dateTime))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                if let lat = post.latitude, let lon = post.longitude {
                                    if let locationName = post.locationName {
                                        Text("Location: \(locationName)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    } else {
                                        Text(String(format: "Location: %.4f, %.4f", lat, lon))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }

                                Button("Comment") {
                                    selectedPost = post
                                    isCommentSheetPresented = true
                                }
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            }
                            .padding(.vertical, 8)
                        }
                        .listStyle(PlainListStyle())
                        .refreshable {
                            fetchPosts()
                        }

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
                    .sheet(isPresented: $isCommentSheetPresented) {
                        if let post = selectedPost {
                            CommentSheet(post: post)
                        }
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
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    isLoggedIn = false // this hides FeedView
                case .failure(let error):
                    print("Logout failed: \(error.localizedDescription)")
                }
            }
        }
        
    }


