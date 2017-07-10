
//
//  CartTotalCell.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-07-09.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

class CartTotalCell: UITableViewCell {

    @IBOutlet weak var totalAmountLabel: UILabel!
    
    var shoppingCart: ShoppingCart! {
        didSet {
            totalAmountLabel.text = "$ \(shoppingCart.total!)"
        }
    }
}
