//
//  InventoryDetails.swift
//  Shopify-Admin
//
//  Created by Zeinab on 26/02/2023.
//

import UIKit
import Kingfisher

class ProductDetailsVC: UIViewController {
    
    var product: Product?
    var flag: Int?
    var producImgs: [String] = []
    var productSizes: [String] = []
    var productColors: [String] = []
    var status: String?
    
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productDiscription: UITextView!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productImgURL: UITextField!
    @IBOutlet weak var ProductImagesTableView: UITableView!
    {
        didSet {
           // ProductImagesTableView.layer.borderWidth = 2
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
                //productSizeTableView.layer.borderWidth = 2
            }
    }
    @IBOutlet weak var productColorTableView: UITableView!  {
        didSet {
            //productColorTableView.layer.borderWidth = 2
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
    @IBOutlet weak var minusQuantatity: UIButton!
    @IBOutlet weak var productStatus: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        product?.images?.forEach({ img in
            self.producImgs.append(img.src)
        })
        
        productSizes = (product?.options?[0].values) ?? []
        productColors = (product?.options?[1].values) ?? []
        
        productName.text = product?.title
        productDiscription.text = product?.body_html
        productPrice.text = product?.variants?[0].price
        productAvaliableQuantatiy.text = String(product?.variants?[0].inventory_quantity ?? 0)
        sku.text = product?.variants?[0].sku
        //productCollection.text = product?
        productType.text = product?.product_type
        
        choose(sender: pollDownProductCollection)
        choose(sender: pollDownProductType)
    }
    
    func choose(sender:UIButton){
        switch sender{
          
        case pollDownProductCollection:
            let c = {(action : UIAction) in
                self.productCollection.text = action.title
            }
            pollDownProductCollection.menu = UIMenu(title:"",children:[
                UIAction(title: "KID",handler: c),
                UIAction(title: "MEN",handler: c),
                UIAction(title: "SALE",handler: c),
                UIAction(title: "WOMEN",handler: c)])
            self.pollDownProductCollection.showsMenuAsPrimaryAction = true
        
        case pollDownProductType:
            let c = {(action : UIAction) in
                self.productType.text = action.title
            }
            pollDownProductType.menu = UIMenu(title:"",children:[
                UIAction(title: "SHOES",handler: c),
                UIAction(title: "ACCESSORIES",handler: c),
                UIAction(title: "T-SHIRTS",handler: c)])
            self.pollDownProductType.showsMenuAsPrimaryAction = true
            
        default:
            break
        }
    }
    @IBAction func addProductImg(_ sender: Any) {
    
        if productImgURL.text != "" {
            producImgs.append(productImgURL.text ?? "NoImg")
            ProductImagesTableView.reloadData()
            
        }else {
            showAlert()
        }
    }
    @IBAction func addProductSize(_ sender: Any) {
        if productSize.text != "" {
            productSizes.append(productSize.text ?? "")
            productSizeTableView.reloadData()
            
        }else {
            showAlert()
        }
    }
    @IBAction func addProductColor(_ sender: Any) {
        if productColor.text != "" {
            productColors.append(productColor.text ?? "")
            productColorTableView.reloadData()
            
        }else {
            showAlert()
        }
    }
    
    @IBAction func minusProductQuantatityByOne(_ sender: Any) {
        if ((Int(productAvaliableQuantatiy.text ?? "") ?? 0) == 1) {
            minusQuantatity.isUserInteractionEnabled = false
        }
        productAvaliableQuantatiy.text = String((Int(productAvaliableQuantatiy.text ?? "") ?? 0) - 1)
    }
    @IBAction func plusProductQuantatityByOne(_ sender: Any) {
        productAvaliableQuantatiy.text = String((Int(productAvaliableQuantatiy.text ?? "") ?? 0) + 1)
    }
    @IBAction func saveProduct(_ sender: Any) {
        switch flag {
        case 1://post to API
            
        case 2://update to API
        default: break
        }
    }
    @IBAction func deleteProduct(_ sender: Any) {
    }
    func showAlert() {
        let alert = UIAlertController(title: "incomplete data", message: "Enter full data", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    

    @IBAction func addProductStatus(_ sender: Any) {
        switch productStatus.selectedSegmentIndex {
        case 0:
            status = "active"
        case 1:
            status = "inactive"
        default:
            break
        }
    }
}

extension ProductDetailsVC : UITableViewDelegate {}
extension ProductDetailsVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case ProductImagesTableView:
            return producImgs.count
            
        case productSizeTableView:
            return productSizes.count
            
        case productColorTableView:
            return productColors.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.layer.borderWidth = 2
        
        switch tableView {
        case ProductImagesTableView:
            
           // cell.image.kf.setImage(with: URL(string: product?.images?[indexPath.row].src ?? ""))
            cell.textLabel?.text = producImgs[indexPath.row]
            
        case productSizeTableView:
            cell.textLabel?.text = productSizes[indexPath.row]
            
        case productColorTableView:
            cell.textLabel?.text = productColors[indexPath.row]
            
        default:
            break
        }
        
        return cell
    }
}
