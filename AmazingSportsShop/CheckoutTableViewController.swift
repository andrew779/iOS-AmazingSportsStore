//
//  CheckoutTableViewController.swift
//  AmazingSportsShop
//
//  Created by Wenzhong Zheng on 2017-07-02.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit
import Stripe
import AFNetworking


class CheckoutTableViewController: UITableViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet weak var securityTextField: UITextField!
    
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var submitOrderButton: UIButton!
    
    var shoppingCart: ShoppingCart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CHECKOUT"
        updateUI()
    }
    
    private func updateUI() {
        if let shoppingCart = shoppingCart {
            if let subtotal = shoppingCart.subtotal, let shipping = shoppingCart.shipping, let tax = shoppingCart.tax, let total = shoppingCart.total {
                subtotalLabel.text = "$\(subtotal)"
                if shipping == 0 {
                    shippingCostLabel.text = "FREE"
                } else {
                    shippingCostLabel.text = "$\(shipping)"
                }
                
                taxLabel.text = "$\(tax)"
                totalLabel.text = "$\(total)"
            }
        }
    }
    
    @IBAction func submitDidTouch(_ sender: Any) {
        // 1 - initiate a stripe card
        var stripeCard = STPCard()
        // 1.1 - get the credit card information from the text fields
        if expirationDateTextField.text?.isEmpty == false {
            let expirationDate = expirationDateTextField.text?.components(separatedBy: "/")
            let expMonth = UInt(expirationDate?[0] ?? "0") ?? 0
            let expYear = UInt(expirationDate?[1] ?? "0") ?? 0
            
            // 2 - send the card information to stripe to get a token
            stripeCard.number = cardNumberTextField.text
            stripeCard.cvc = securityTextField.text
            stripeCard.expMonth = expMonth
            stripeCard.expYear = expYear
            
            // 3 - validate the card numbers
            STPAPIClient.shared().createToken(withCard: stripeCard, completion: { (token, error) in
                if let error = error {
                    //handle error
                    self.handleError(error:error)
                    return
                }
                
                //post the token to stripe using webserver
                if let token = token {
                    self.postToStripe(token:token)
                }
                
            })
        }
    }
    
    private func postToStripe(token: STPToken) {
        //url to server
        let url = "https://aqueous-fortress-68279.herokuapp.com/payment.php"
        //"http://localhost/nike-retail/payment.php"
        let params: [String : Any] = [
            "stripeToken" : token.tokenId,
            "amount" : shoppingCart.total!,
            "currency" : "cad",
            "description" : self.emailTextField.text ?? ""]
        let _ = AFHTTPSessionManager().post(url, parameters: params, success: { (operation, responseObject) in
            if let response = responseObject as? [String : String] {
                print(response["status"]! + "---------" + response["message"]!)
                self.handleSuccess(message: response["message"]!)
            }
        }) { (operation, error) in
            self.handleError(error: error)
        }
    }
    
    private func handleSuccess(message: String) {
        let alert = UIAlertController(title: "Succeed", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func handleError(error: Error){
        let alert = UIAlertController(title: "Ooops! Error", message: error.localizedDescription, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
