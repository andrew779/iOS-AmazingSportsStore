//
//  ShoppingCartItemCell.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-07-01.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

class ShoppingCartItemCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    var product: Product! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        productImageView.image = nil
        if let imageLink = product.featuredImageLink {
            FIRImage.downloadImage(url: imageLink, completion: { (image, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                self.productImageView.image = image
            })
        }
        
        productNameLabel.text = product.name
        productPriceLabel.text = "$\(product.price ?? 0)"
        
    }
}
