//
//  ProductImageVC.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-07-01.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

class ProductImageVC: UIViewController {

    @IBOutlet weak var imageView:UIImageView!
    
    var imageLink: String? {
        didSet {
            FIRImage.downloadImage(url: imageLink!) { (image, error) in
                if let image = image {
                    self.imageView.image = image
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
