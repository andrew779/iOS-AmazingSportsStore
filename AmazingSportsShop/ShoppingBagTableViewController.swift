//
//  ShoppingBagTableViewController.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-07-01.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

class ShoppingBagTableViewController: UITableViewController {

    var products: [Product]?
    var shoppingCart = ShoppingCart()
    
    struct Storyboard {
        static let numberOfItemsCell = "numberOfItemsCell"
        static let itemCell = "itemCell"
        static let cartDetailCell = "cartDetailCell"
        static let totalCell = "totalCell"
        static let checkoutButtonCell = "checkoutButtonCell"
        static let showCheckOutVC = "ShowCheckOut"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 74
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProducts()
    }

    func fetchProducts() {
        self.products?.removeAll()
        self.tableView.reloadData()
        shoppingCart.fetch {
            [weak self] () in
            self?.products = self?.shoppingCart.products
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showCheckOutVC {
            let checkOutTVC = segue.destination as! CheckoutTableViewController
                checkOutTVC.shoppingCart = shoppingCart
        }
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let products = products {
            return products.count + 4
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let products = products else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.numberOfItemsCell, for: indexPath) as! NumberOfItemsCell
            cell.numberOfItemsLabel.text = "0 ITEM"
            return cell
        }
            
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.numberOfItemsCell, for: indexPath) as! NumberOfItemsCell
            cell.numberOfItemsLabel.text = products.count == 1 ? "\(products.count) ITEM" : "\(products.count) ITEMS"
            return cell
        } else if indexPath.row == products.count + 1 {
            //cart detail cell
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cartDetailCell, for: indexPath) as! CartSubtotalCell
            cell.shoppingCart = shoppingCart
            return cell
            
        } else if indexPath.row == products.count + 2 {
            //cart total cell
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.totalCell, for: indexPath) as! CartTotalCell
            cell.shoppingCart = shoppingCart
            return cell
        } else if indexPath.row == products.count + 3 {
            //checkout button cell
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.checkoutButtonCell, for: indexPath)
            
            return cell
        } else {
            //item cell
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.itemCell, for: indexPath) as! ShoppingCartItemCell
            if products.count >= 1 {
                cell.product = products[indexPath.row - 1]
            }
            return cell
        }
        
    }
    
}























