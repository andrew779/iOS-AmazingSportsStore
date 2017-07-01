//
//  ProductImagesHeaderView.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-07-01.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

class ProductImagesHeaderView: UIView {

    @IBOutlet weak var pageControl: UIPageControl!

}

extension ProductImagesHeaderView: ProductImagesPVCDelegate {
    func setupPageController(numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
    }
    func turnPageController(to index: Int) {
        pageControl.currentPage = index
    }
}
