//
//  ShoppingCart.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-07-07.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit
import Firebase

private let taxPercentage = 0.13
private let freeShippingLimit = 50.00
private let defaultShippingFee = 7.99

class ShoppingCart {
    var products: [Product]?
    var shipping: Double?
    var subtotal: Double?
    var tax: Double?
    var total: Double?
    
    func fetch(completion: @escaping(Error?) -> Void) {
        let userUID = Firebase.Auth.auth().currentUser!.uid
        let ref = FirebaseReference.users(uid: userUID).reference().child("shoppingCart")
        ref.runTransactionBlock({ (currentData:MutableData) -> TransactionResult in
            
            self.products = [Product]()
            
            if let cart = currentData.value as? [String : Any],
                let shipping = cart["shipping"] as? Double,
                let subtotal = cart["subtotal"] as? Double,
                let tax = cart["tax"] as? Double,
                let total = cart["total"] as? Double,
                let productDictionary = cart["products"] as? [String : Any] {
                
                
                
                self.shipping = shipping
                self.subtotal = subtotal
                self.tax = tax
                self.total = total
                
                
                for (_, productDict) in productDictionary {
                    if let productDict = productDict as? [String : Any] {
                        let product = Product(dictionary: productDict)
                        self.products?.append(product)
                    }
                }
            }
                
            
                
            
            
            return Firebase.TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            completion(error)
        }
    }
    
    class func remove(product: Product,completion: @escaping ((Error?) -> Void)) {
        let userUID = Firebase.Auth.auth().currentUser!.uid
        let productUID = product.uid!
        let ref = FirebaseReference.users(uid: userUID).reference().child("shoppingCart/products/\(productUID)")
        ref.setValue(nil) { (error, dataRef) in
            calculateCart(product: product, completion: { succeed in
                completion(succeed)
            })
        }

        
        
    }
    
    class func add(product: Product) {
        let useUID = Firebase.Auth.auth().currentUser!.uid
        let ref = FirebaseReference.users(uid: useUID).reference().child("shoppingCart")
        
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            // the last-known state of the current shopping cart, nil if there's none in shopping cart
            var cart = currentData.value as? [String : Any] ?? [:]
            var productDictionary = cart["products"] as? [String : Any] ?? [:]
            
            //add new product to the dictionary
            productDictionary[product.uid!] = product.toDictionary()
            //re-calculate the detail of the shopping cart - total, subtotal, shipping, tax
            var subtotal: Double = 0
            var shipping: Double = 0
            var tax: Double = 0
            var total: Double = 0
            
            for(_, prodDict) in productDictionary {
                if let prodDict = prodDict as? [String : Any] {
                    let price = prodDict["price"] as! Double
                    subtotal += price
                }
            }
            
            if subtotal >= freeShippingLimit || subtotal == 0 {
                shipping = 0
            } else {
                shipping = defaultShippingFee
            }
            
            tax = (subtotal + shipping) * taxPercentage
            total = subtotal + shipping + tax
            
            //update back the value to cart
            cart["subtotal"] = subtotal
            cart["shipping"] = shipping
            cart["tax"] = tax
            cart["total"] = total
            cart["products"] = productDictionary
            
            //return back the value of the currentData as the new updated cart - so upload back to firebase
            currentData.value = cart
            return Firebase.TransactionResult.success(withValue: currentData)
            
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
        }
    }
    
    private class func calculateCart(product: Product, completion: @escaping ((Error?) -> Void)) {
        let useUID = Firebase.Auth.auth().currentUser!.uid
        let ref = FirebaseReference.users(uid: useUID).reference().child("shoppingCart")

        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            // the last-known state of the current shopping cart, nil if there's none in shopping cart
            var cart = currentData.value as? [String : Any] ?? [:]
            let productDictionary = cart["products"] as? [String : Any] ?? [:]

            //re-calculate the detail of the shopping cart - total, subtotal, shipping, tax
            var subtotal: Double = 0
            var shipping: Double = 0
            var tax: Double = 0
            var total: Double = 0

            for(_, prodDict) in productDictionary {
                if let prodDict = prodDict as? [String : Any] {
                    let price = prodDict["price"] as! Double
                    subtotal += price
                }
            }

            if subtotal >= freeShippingLimit || subtotal == 0 {
                shipping = 0
            } else {
                shipping = defaultShippingFee
            }

            tax = (subtotal + shipping) * taxPercentage
            total = subtotal + shipping + tax

            //update back the value to cart
            cart["subtotal"] = subtotal
            cart["shipping"] = shipping
            cart["tax"] = tax
            cart["total"] = total
            cart["products"] = productDictionary

            //return back the value of the currentData as the new updated cart - so upload back to firebase
            currentData.value = cart
            return Firebase.TransactionResult.success(withValue: currentData)

        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            completion(error)
        }
    }
}
