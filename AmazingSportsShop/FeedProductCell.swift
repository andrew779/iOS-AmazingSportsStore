//
//  FeedProductCell.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-06-30.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

class FeedProductCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    var product: Product? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        if let product = product {
            //download the product image
            if let imageLinks = product.imageLinks, let imageLink = imageLinks.first {
                FIRImage.downloadImage(url: imageLink, completion: { (image, error) in
                    if error == nil {
                        self.productImageView.image = image
                    }
                })
            }
            
            productImageView.image = product.images?.first
            productNameLabel.text = product.name
            productPriceLabel.text = "$ \(product.price ?? 0)"
        }
        
    }

}
