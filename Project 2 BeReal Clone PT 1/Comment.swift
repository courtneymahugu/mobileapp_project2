//
//  Comment.swift
//  Project 3 BeReal Clone PT 2
//
//  Created by Courtney Mahugu on 4/24/25.
//
import Foundation
import ParseSwift

struct Comment: ParseObject {
    var originalData: Data?
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var text: String?
    var user: User?
    var post: Post?
    
    init() {}
}
