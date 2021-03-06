//
//  ProductDetailTVC.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-07-01.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

class ProductDetailTVC: UITableViewController {

    var product: Product!
    
    struct Storyboard {
        static let productDetailCell = "ProductDetailCell"
        static let buyButtonCell = "BuyButtonCell"
        static let showProductDetailCell = "ShowProductDetailCell"
        static let toProductImagesPVCSuge = "toProductImagesPVCSuge"
        static let suggestionTableViewCell = "SuggestionTableViewCell"
        static let suggestionCollectionViewCell = "SuggestionCollectionViewCell"
    }
    
    @IBOutlet weak var productImagesHeaderView: ProductImagesHeaderView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.toProductImagesPVCSuge {
            if let imagesPVC = segue.destination as? ProductImagesPVC {
                imagesPVC.product = product
                imagesPVC.pageViewControllerDelegate = productImagesHeaderView
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = product.name
        tableView.estimatedRowHeight = 74
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.productDetailCell, for: indexPath) as! ProductDetailCell
            cell.product = product
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.buyButtonCell, for: indexPath) as! BuyButtonCell
            cell.product = product
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.showProductDetailCell, for: indexPath)
            cell.selectionStyle = .none
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.suggestionTableViewCell, for: indexPath) as! SuggestionTableViewCell
            cell.selectionStyle = .none
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return tableView.bounds.width + 68
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            if let cell = cell as? SuggestionTableViewCell {
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                cell.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ProductDetailTVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.relatedProductUIDs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.suggestionCollectionViewCell, for: indexPath) as! SuggestionCollectionViewCell
        if let uid = product.relatedProductUIDs?[indexPath.item] {
            
            FirebaseReference.products(uid: uid).reference().observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String : Any] else {return}
                let foundProduct = Product(dictionary: dictionary)
                cell.imageLink = foundProduct.featuredImageLink
            })
        }
        return cell
    }
    
    func findingRelatedProduct(uid: String) -> Product?{
        var foundProduct:Product?
        FirebaseReference.products(uid: uid).reference().observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            foundProduct = Product(dictionary: dictionary)
            
        })
        return foundProduct
    }
}

extension ProductDetailTVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: collectionView navigation
        let newDetailTVC = ProductDetailTVC()
        //selected product uid
        guard let uid = product.relatedProductUIDs?[indexPath.item] else {return}
        FirebaseReference.products(uid: uid).reference().observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            let foundProduct = Product(dictionary: dictionary)
            newDetailTVC.product = foundProduct
            self.product = foundProduct
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
            
        })
        
    }
}

extension ProductDetailTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 5.0
            layout.minimumInteritemSpacing = 2.5
            
            let itemWidth = (collectionView.bounds.width - 5.0) / 2.0
            return CGSize(width: itemWidth, height: itemWidth)
        }
        return .zero
    }
}

// MARK: - BuyButtonCellDelegate
extension ProductDetailTVC: BuyButtonCellDelegate {
    func addToCart(product: Product) {
        ShoppingCart.add(product: product)
    }
}



