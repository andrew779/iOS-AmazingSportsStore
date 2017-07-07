//
//  FirebaseReference.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-07-04.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import Foundation
import Firebase

enum FirebaseReference {
    case root
    case users(uid: String)
    case products(uid: String)
    
    // MARK: - Public
    func reference() -> DatabaseReference {
        switch self {
        case .root:
            return rootRef
        default:
            return rootRef.child(path)
        }
    }
    
    private var rootRef: DatabaseReference {
        return Database.database().reference()
    }
    
    private var path: String {
        switch self {
        case .root:
            return ""
        case .users(let uid):
            return "user/\(uid)"
        case .products(let uid):
            return "products/\(uid)"
        }
    }
}

enum FirebaseStorageReference {
    case root
    case profileImages  // for user's profile image
    case images //general images in app
    
    private var baseRef: StorageReference {
        return Storage.storage().reference()
    }
    
    private var path: String {
        switch self {
        case .root:
            return ""
        case .profileImages:
            return "profileImages"
        case .images:
            return "images"
        }
    }
    
    func reference() -> StorageReference {
        return baseRef.child(path)
    }
}






