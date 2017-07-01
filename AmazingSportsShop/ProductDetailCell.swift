//
//  ProductDetailCell.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-06-30.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

class ProductDetailCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    var product: Product? {
        didSet {
            productNameLabel.text = product?.name
            productDescriptionLabel.text = product?.description
        }
    }

}
