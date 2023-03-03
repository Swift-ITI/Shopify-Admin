//
//  InventoryDetails.swift
//  Shopify-Admin
//
//  Created by Zeinab on 26/02/2023.
//

import UIKit

class InventoryDetails: UIViewController {

    
    @IBOutlet weak var sku: UITextField! {
        didSet {
            sku.layer.borderWidth = 2
            sku.layer.borderColor = UIColor(named: "SecondaryColor")?.cgColor
            sku.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var quantityTxtField: UITextField!
    @IBOutlet weak var available: UILabel!
    @IBOutlet weak var steepper: UIStepper!
    @IBOutlet weak var quantatiy: UILabel!
    var product:Product?
    override func viewDidLoad() {
        super.viewDidLoad()
        productName.text = product?.title
        sku.text = product?.variants?.first?.sku
        steepper.value = Double(product?.variants?.first?.inventory_quantity ?? 0)
        available.text = product?.variants?.first?.inventory_quantity.formatted()
        quantatiy.text = String(Int(steepper.value))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func stepper(_ sender: Any) {
        quantatiy.text = String(Int(steepper.value))
    }
}
