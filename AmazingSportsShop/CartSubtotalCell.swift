//
//  CartSubtotalCell.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-07-09.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

class CartSubtotalCell: UITableViewCell {
    
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var taxAmountLabel: UILabel!
    
    var shoppingCart: ShoppingCart! {
        didSet {
            subtotalLabel.text = "$ \(shoppingCart.subtotal ?? 0)"
            shippingCostLabel.text = shoppingCart.shipping! == 0 ? "FREE" : "$ \(shoppingCart.shipping!)"
            taxAmountLabel.text = "$ \(shoppingCart.tax!)"
        }
    }
}
