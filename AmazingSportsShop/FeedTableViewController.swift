//
//  FeedTableViewController.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-06-30.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit
import Firebase

class FeedTableViewController: UITableViewController {

    var products: [Product]?
    
    struct Storyboard {
        static let feedProductCell = "FeedProductCell"
        static let toProductDetailSegue = "toProductDetailSegue"
        static let loginViewController = "LoginViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchProducts()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthentication()
    }
    
    //check authentication
    func checkAuthentication() {
        if Firebase.Auth.auth().currentUser == nil {
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboard.loginViewController)
            present(loginVC, animated: true)
        }
    }
    
    // MARK: - Fetching from Firebase
    
    func fetchProducts() {
        Product.fetchProducts { (products) in
            self.products = products
            self.tableView.reloadData()
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.toProductDetailSegue {
            let destination = segue.destination as! ProductDetailTVC
            destination.product = sender as! Product
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.feedProductCell, for: indexPath) as! FeedProductCell
        if let products = products {
            let product = products[indexPath.row]
            cell.product = product
            cell.selectionStyle = .none
        }
        
        return cell
    }

    // MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Storyboard.toProductDetailSegue, sender: self.products?[indexPath.row])
    }
}
