//
//  BuyButtonCell.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-06-30.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

protocol BuyButtonCellDelegate: class {
    func addToCart(product: Product)
}

class BuyButtonCell: UITableViewCell {

    @IBOutlet weak var buyButton: UIButton!
    
    weak var delegate: BuyButtonCellDelegate?
    
    var product: Product! {
        didSet{
            buyButton.setTitle("BUY FOR $\(product.price ?? 0)", for: .normal)
        }
    }
    
    @IBAction func buyButtonDidTap() {
        delegate?.addToCart(product: product)
    }
}
