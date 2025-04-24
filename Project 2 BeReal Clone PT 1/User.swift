//
//  User.swift
//  Project 3 BeReal Clone PT 2
//
//  Created by Courtney Mahugu on 3/10/25.
//

import Foundation
import ParseSwift

struct User: ParseUser {
    var emailVerified: Bool?
    
    var authData: [String : [String : String]?]?
    
    var originalData: Data?
    
    var ACL: ParseSwift.ParseACL?
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var lastPostedAt: Date?

    // Custom properties (e.g., username, email, password)
    var username: String?
    var email: String?
    var password: String?
}
