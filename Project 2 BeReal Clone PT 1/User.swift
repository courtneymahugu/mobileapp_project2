//
//  User.swift
//  Project 2 BeReal Clone PT 1
//
//  Created by Courtney Mahugu on 3/10/25.
//

import Foundation
import ParseSwift

//struct User: ParseObject {
//    var originalData: Data?
//    
//    var ACL: ParseSwift.ParseACL?
//    
//    // Default properties available for a Parse user
//    var objectId: String?
//    var createdAt: Date?
//    var updatedAt: Date?
//
//    // Custom properties (username and password are part of the base Parse user object)
//    var username: String?
//    var password: String?
//
//    // Optional: You can add other fields like email, profile image, etc.
//    var email: String?
//}

struct User: ParseUser {
    var emailVerified: Bool?
    
    var authData: [String : [String : String]?]?
    
    var originalData: Data?
    
    var ACL: ParseSwift.ParseACL?
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?

    // Custom properties (e.g., username, email, password)
    var username: String?
    var email: String?
    var password: String?
}
