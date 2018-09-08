//
//  StoreViewController.swift
//  Tappy Fingers
//
//  Created by ìÐąrκÐųçκ™ ☠ on 12/27/17.
//  Copyright © 2017 ìÐąrκÐųçκ™ ☠. All rights reserved.
//

import UIKit
import StoreKit

class StoreViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {

    @IBOutlet var label1: UILabel!
    
    @IBOutlet var label2: UILabel!
    
    @IBOutlet var label3: UITextView!
    
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var returnButton: UIButton!
    
    var product: SKProduct?
    var productID="com.idarkduck.tappyfingers.removeads"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label1.layer.cornerRadius = 5.0
        label2.layer.cornerRadius = 5.0
        label3.layer.cornerRadius = 5.0
        buyButton.layer.cornerRadius = 5.0
        returnButton.layer.cornerRadius = 5.0
        
//        label1.clipsToBounds = true
//        label2.clipsToBounds = true
//        label3.clipsToBounds = true
//        buyButton.clipsToBounds = true
//        returnButton.clipsToBounds = true
        
        buyButton.isEnabled = false
        SKPaymentQueue.default().add(self)
        getPurchaseInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func purchaseButton(_ sender: Any) {
        
        let payment = SKPayment(product: product!)
        SKPaymentQueue.default().add(payment)
    }
    
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getPurchaseInfo(){
        if(SKPaymentQueue.canMakePayments()){
            let request = SKProductsRequest(productIdentifiers: NSSet(objects: self.productID) as! Set<String>)
            request.delegate = self
            request.start()
        }
        else{
            label2.text="Warning"
            label3.text="Please enable in app purchases in your settings"
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        var products = response.products
        if(products.count==0){
            label2.text="Warning"
            label3.text="Product not found"
        }
        else{
            product = products[0]
            label1.text = product!.localizedTitle
            label2.text = product!.localizedDescription
            buyButton.isEnabled = true
        }
        let invalids = response.invalidProductIdentifiers
        
        for product in invalids {
            print("product not found: \(product)")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.purchased:
                
                SKPaymentQueue.default().finishTransaction(transaction)
                label2.text = "Thank you"
                label3.text = "The product has been purchase"
                buyButton.isEnabled = false
                
                let save = UserDefaults.standard
                save.set(true, forKey: "Purchase")
                save.synchronize()
                
                
            case SKPaymentTransactionState.failed:
                
                SKPaymentQueue.default().finishTransaction(transaction)
                label2.text = "Warning"
                label3.text = "The product has not been purchase"
                
            default:
                break
            }

        }
    

    }

}
