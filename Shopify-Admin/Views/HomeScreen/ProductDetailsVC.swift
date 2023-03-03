//
//  InventoryDetails.swift
//  Shopify-Admin
//
//  Created by Zeinab on 26/02/2023.
//

import UIKit

class ProductDetailsVC: UIViewController {
    
    var product: Product?
    var flag: Int?
    
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productDiscription: UITextView!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productImgURL: UITextField!
    @IBOutlet weak var ProductImagesTableView: UITableView!
    {
        didSet {
            ProductImagesTableView.layer.borderWidth = 2
        }
    }
    @IBOutlet weak var productCollection: UILabel!
    @IBOutlet weak var pollDownProductCollection: UIButton!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var pollDownProductType: UIButton!
    @IBOutlet weak var productSize: UITextField!
    @IBOutlet weak var productColor: UITextField!
    @IBOutlet weak var productSizeTableView: UITableView! {
            didSet {
                productSizeTableView.layer.borderWidth = 2
            }
    }
    @IBOutlet weak var productColorTableView: UITableView!  {
        didSet {
            productColorTableView.layer.borderWidth = 2
        }
}
    @IBOutlet weak var productAvaliableQuantatiy: UILabel!
    @IBOutlet weak var productAvaliableManually: UITextField!
    @IBOutlet weak var sku: UITextField! {
        didSet {
            sku.layer.borderWidth = 2
            sku.layer.borderColor = UIColor(named: "SecondaryColor")?.cgColor
            sku.layer.cornerRadius = 10
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       // productName.text = product?.title
       // sku.text = product?.variants?.first?.sku
       // steepper.value = Double(product?.variants?.first?.inventory_quantity ?? 0)
     //   available.text = product?.variants?.first?.inventory_quantity.formatted()
    //    quantatiy.text = String(Int(steepper.value))
        // Do any additional setup after loading the view.
    }

//    @IBAction func stepper(_ sender: Any) {
//        quantatiy.text = String(Int(steepper.value))
//    }
    
    @IBAction func addProductImg(_ sender: Any) {
    }
    @IBAction func addProductSize(_ sender: Any) {
    }
    @IBAction func addProductColor(_ sender: Any) {
    }
    
    @IBAction func minusProductQuantatityByOne(_ sender: Any) {
    }
    @IBAction func plusProductQuantatityByOne(_ sender: Any) {
    }
    @IBAction func saveProduct(_ sender: Any) {
    }
    @IBAction func deleteProduct(_ sender: Any) {
    }
}

extension ProductDetailsVC : UITableViewDelegate {}
extension ProductDetailsVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case ProductImagesTableView:
            return product?.images?.count ?? 0
            
        case productSizeTableView:
            return product?.options?[0].values?.count ?? 0
            
        case productColorTableView:
            return product?.options?[1].values?.count ?? 0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        
        switch tableView {
        case ProductImagesTableView: break
            
        case productSizeTableView: break
            
        case productColorTableView: break
            
        default:
            break
        }
        
        return cell
    }
}
