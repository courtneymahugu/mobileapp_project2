//
//  Post.swift
//  Project 2 BeReal Clone PT 1
//
//  Created by Courtney Mahugu on 3/10/25.
//

import Foundation
import ParseSwift

struct Post: ParseObject {
    var originalData: Data?
    
    var ACL: ParseSwift.ParseACL?
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    var username: String? // Assuming you have a username field in your Post
    var caption: String?  // Caption or other details
    var image: ParseFile? // Image file (ParseFile)

}
