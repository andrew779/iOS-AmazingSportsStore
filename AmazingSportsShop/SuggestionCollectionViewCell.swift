//
//  SuggestionCollectionViewCell.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-07-01.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

class SuggestionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var imageLink: String! {
        didSet {
            FIRImage.downloadImage(url: imageLink) { (image, error) in
                if error != nil {
                    print(error!)
                }
                    self.imageView.image = image
                    self.layoutIfNeeded()
//                    self.setNeedsLayout()
            }
        }
    }
}
