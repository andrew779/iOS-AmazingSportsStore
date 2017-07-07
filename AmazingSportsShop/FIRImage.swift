//
//  FIRImage.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-07-04.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import Foundation
import Firebase

class FIRImage {
    var image: UIImage
    var downloadURL: String?
    var ref: StorageReference!
    
    init(image: UIImage) {
        self.image = image
    }
}

extension FIRImage {
    func saveProfileImage(userUID: String, completion: @escaping (Error?) -> Void) {
        let resizedImage = image.resized()
        guard let imageData = UIImageJPEGRepresentation(resizedImage, 0.9) else{return}
        ref = FirebaseStorageReference.profileImages.reference().child(userUID)
        downloadURL = ref.description
        ref.putData(imageData, metadata: nil) { (metaData, err) in
            completion(err)
        }
    }
    
    func save(_ uid: String, completion: @escaping (Error?) -> Void)
    {
        let resizedImage = image.resized()
        guard let imageData = UIImageJPEGRepresentation(resizedImage, 0.9) else {return}
        
        ref = FirebaseStorageReference.images.reference().child(uid)
        downloadURL = ref.description
        
        ref.putData(imageData, metadata: nil) { (metaData, error) in
            completion(error)
        }
    }
}

extension FIRImage {
    class func downloadProfileImage(_ uid: String, completion: @escaping (UIImage?, Error?) -> Void)
    {
        
        FirebaseStorageReference.profileImages.reference().child(uid).getData(maxSize: 1 * 1024 * 1024) { (imageData, error) in
            if error == nil && imageData != nil {
                let image = UIImage(data: imageData!)
                completion(image, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func downloadImage(url: String, completion: @escaping (UIImage?, Error?) -> Void)
    {
        
        Storage.storage().reference(forURL: url).getData(maxSize: 1 * 1024 * 1024) { (imageData, error) in
            if error == nil && imageData != nil {
                let image = UIImage(data: imageData!)
                completion(image, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func downloadImage(uid: String, completion: @escaping (UIImage?, Error?) -> Void)
    {
        FirebaseStorageReference.images.reference().child(uid).getData(maxSize: 1 * 1024 * 1024) { (imageData, error) in
            if error == nil && imageData != nil {
                let image = UIImage(data: imageData!)
                completion(image, error)
            } else {
                completion(nil, error)
            }
        }
    }
}

private extension UIImage {
    func resized() -> UIImage {
        let height: CGFloat = 800.0
        let ratio = self.size.width / self.size.height
        let width = height * ratio
        
        let newSize = CGSize(width: width, height: height)
        let newRectangle = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: newRectangle)
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
}
