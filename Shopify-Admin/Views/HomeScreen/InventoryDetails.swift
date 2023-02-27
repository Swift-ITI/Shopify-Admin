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
    @IBOutlet weak var onHand: UILabel!
    @IBOutlet weak var commited: UILabel!
    @IBOutlet weak var available: UILabel!
    @IBOutlet weak var steepper: UIStepper!
    @IBOutlet weak var quantatiy: UILabel!
    @IBOutlet weak var quantatiyViewDetal: UIView! {
        didSet {
            quantatiyViewDetal.layer.borderWidth = 2
            quantatiyViewDetal.layer.borderColor = UIColor(named: "SecondaryColor")?.cgColor
            quantatiyViewDetal.layer.cornerRadius = 10
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func stepper(_ sender: Any) {
        quantatiy.text = String(Int(steepper.value))
        
    }
}
