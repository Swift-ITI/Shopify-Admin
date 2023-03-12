//
//  StoreVC.swift
//  Shopify-Admin
//
//  Created by Adham Samer on 27/02/2023.
//

import UIKit

class StoreVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func showCustomers(_ sender: Any) {
        let CustomerObj : CustomersVC = self.storyboard?.instantiateViewController(withIdentifier: "customers") as! CustomersVC
        self.navigationController?.pushViewController(CustomerObj, animated: true)
    }
}
