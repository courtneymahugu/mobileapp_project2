//
//  CommentSheet.swift
//  Project 3 BeReal Clone PT 2
//
//  Created by Courtney Mahugu on 4/24/25.
//
import SwiftUI
import ParseSwift

struct CommentSheet: View {
    let post: Post
    @State private var newCommentText = ""
    @State private var comments: [Comment] = []

    var body: some View {
        NavigationView {
            VStack {
                List(comments, id: \.objectId) { comment in
                    VStack(alignment: .leading) {
                        Text(comment.user?.username ?? "Anonymous")
                            .font(.headline)
                        Text(comment.text ?? "")
                    }
                    .padding(.vertical, 4)
                }

                Divider()

                HStack {
                    TextField("Add a comment...", text: $newCommentText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Send") {
                        postComment()
                    }
                }
                .padding()
            }
            .navigationTitle("Comments")
            .onAppear {
                fetchComments()
            }
        }
    }

    func fetchComments() {
//        Comment.query("post" == post.objectId)
        guard let postPointer = try? Pointer(post) else { return }
        Comment.query("post" == postPointer)
            .include("user")
            .order([.ascending("createdAt")])
            .find { result in
                switch result {
                case .success(let fetched):
                    comments = fetched
                case .failure(let error):
                    print("Error fetching comments: \(error.localizedDescription)")
                }
            }
    }

    func postComment() {
        guard !newCommentText.isEmpty, let user = User.current else { return }

        var comment = Comment()
        comment.text = newCommentText
        comment.user = user
        comment.post = post

        comment.save { result in
            switch result {
            case .success(let saved):
                comments.append(saved)
                newCommentText = ""
            case .failure(let error):
                print("Error saving comment: \(error.localizedDescription)")
            }
        }
    }
}
