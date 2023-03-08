//
//  InventoryDetails.swift
//  Shopify-Admin
//
//  Created by Zeinab on 26/02/2023.
//

import Kingfisher
import UIKit

class ProductDetailsVC: UIViewController {
    
    var product: Product?
    var productVM: ViewModel?
    var flag: Int?
    var producImgs: [[String: Any]] = []
    var productSizes: [String] = []
    var productColors: [String] = []
    var status: String?
    var product_collection : String = ""
    
    
    @IBOutlet weak var imgCollectionView: UICollectionView! {didSet {
        imgCollectionView.delegate = self
        imgCollectionView.dataSource = self
        imgCollectionView.layer.borderWidth = 2
        imgCollectionView.layer.borderColor = UIColor(named: "SecondaryColor")?.cgColor
        imgCollectionView.layer.cornerRadius = 20
        
    }}
    @IBOutlet weak var productVendor: UITextField!
    @IBOutlet weak var save_editBtn: UIButton!
    @IBOutlet var productName: UITextField!
    @IBOutlet var productDiscription: UITextView!
    @IBOutlet var productPrice: UITextField!
    @IBOutlet var productImgURL: UITextField!
    @IBOutlet var productCollection: UILabel!
    @IBOutlet var pollDownProductCollection: UIButton!
    @IBOutlet var productType: UILabel!
    @IBOutlet var pollDownProductType: UIButton!
    @IBOutlet var productSize: UITextField!
    @IBOutlet var productColor: UITextField!
    @IBOutlet var productAvaliableQuantatiy: UILabel!
    @IBOutlet var productAvaliableManually: UITextField!
    @IBOutlet var sku: UITextField! {
        didSet {
            sku.layer.borderWidth = 2
            sku.layer.borderColor = UIColor(named: "SecondaryColor")?.cgColor
            sku.layer.cornerRadius = 10
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch flag {
        case 1:
            save_editBtn.setTitle("save", for: .normal)
        case 2:
            save_editBtn.setTitle("edit", for: .normal)
        default:
            break
        }
        
        let nib = UINib(nibName: "ProductImage", bundle: nil)
        imgCollectionView.register(nib, forCellWithReuseIdentifier: "productImg")
        
        
        productVM = ViewModel()
        
        product?.images?.forEach({ img in
            self.producImgs.append(["src": img.src])
        })
        
        productSizes = (product?.options?[0].values) ?? []
        productColors = (product?.options?[1].values) ?? []
        
        productSize.text = product?.options?[0].values?.first
        productColor.text = product?.options?[1].values?.first
        
        productName.text = product?.title
        productDiscription.text = product?.body_html
        productPrice.text = product?.variants?[0].price
        productAvaliableQuantatiy.text = String(product?.variants?[0].inventory_quantity ?? 0)
        productCollection.text = product_collection
        sku.text = product?.variants?[0].sku
        productType.text = product?.product_type
        productVendor.text = product?.vendor
        
        choose(sender: pollDownProductCollection)
        choose(sender: pollDownProductType)
    }
    
    func choose(sender: UIButton) {
        switch sender {
        case pollDownProductCollection:
            let c = { (action: UIAction) in
                self.productCollection.text = action.title
            }
            pollDownProductCollection.menu = UIMenu(title: "", children: [
                UIAction(title: "KID", handler: c),
                UIAction(title: "MEN", handler: c),
                UIAction(title: "SALE", handler: c),
                UIAction(title: "WOMEN", handler: c)])
            pollDownProductCollection.showsMenuAsPrimaryAction = true
            
        case pollDownProductType:
            let c = { (action: UIAction) in
                self.productType.text = action.title
            }
            pollDownProductType.menu = UIMenu(title: "", children: [
                UIAction(title: "SHOES", handler: c),
                UIAction(title: "ACCESSORIES", handler: c),
                UIAction(title: "T-SHIRTS", handler: c)])
            pollDownProductType.showsMenuAsPrimaryAction = true
            
        default:
            break
        }
    }
    
    @IBAction func addProductImg(_ sender: Any) {
        if productImgURL.text != "" {
            producImgs.append(["src": productImgURL.text ?? "NoImg"])
            //reload collction view data
            
        } else {
            showAlert(title: "Failed", msg: "Add Img")
        }
    }
    
    @IBAction func saveProduct(_ sender: Any) {
        if(productName.text != "" && productDiscription.text != "" && productPrice.text != "" && productCollection.text != "" && productType.text != "" && sku.text != "" && !(producImgs.isEmpty && productSizes.isEmpty && productColors.isEmpty)){
            
            switch flag {
            case 1:
                postData()
                break
            case 2: // update to API
                putData()
            default: break
            }
        }else {showAlert(title: "missing data", msg: "Please enter all fields")}
        
    }
    
    @IBAction func deleteProduct(_ sender: Any) {
        switch flag {
        case 1:
            showAlert(title: "Failed", msg: "Can't delete")
        case 2:
            let alert = UIAlertController(title: "Delete Product", message: "Are u sure to delete product?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.productVM?.deleteProduct(target: .deleteProductByID(productID: self.product?.id ?? 0))
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
                
            }))
            present(alert, animated: true, completion: nil)
        default: break
            
        }
    }
    
    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}


// MARK: POST

extension ProductDetailsVC {
    func postData() {
       
        let parameters: [String: Any] = [
            "product": [
                "title": productName.text ?? "",
                "body_html": productDiscription.text ?? "",
                "vendor": productVendor.text ?? "",
                "product_type": productType.text ?? 0,
                "variants": [
                    [
                        "price": productPrice.text ?? "",
                        "sku": sku.text ?? "",
                       // "position": 1,
                        "inventory_quantity": productAvaliableQuantatiy.text ?? "",
                        "option1": productSize.text ?? "",//productSizes[0],
                        "option2": productColor.text ?? "",//productColors[0],
                    ]
                ],
                "options": [
                    [
                        "name": "Size",
                        "position": 1,
                        "values": [productSize.text ?? ""],
                    ],
                    [
                        "name": "Color",
                        "position": 2,
                        "values": [productColor.text ?? ""],
                    ],
                ],
                "images": producImgs,
            ]
        ]
        switch product_collection {
        case "All" :
            productVM?.postProduct(target: .allProducts, parameters: parameters)
        case "Kids" :
            productVM?.postProduct(target: .catigoriesProducts(id: CatigoryID.kids.id), parameters: parameters)
        case "Men" :
            productVM?.postProduct(target: .catigoriesProducts(id: CatigoryID.men.id), parameters: parameters)
        case "Sale" :
            productVM?.postProduct(target: .catigoriesProducts(id: CatigoryID.sale.id), parameters: parameters)
        case "Women" :
            productVM?.postProduct(target: .catigoriesProducts(id: CatigoryID.women.id), parameters: parameters)
        default:
            showAlert(title: "Oh ..))", msg: "some thing wrong please try again")
            
        }
       
        showAlert(title: "Done", msg: "Added Successfully")
    }
    
    //MARK: Edit

    func putData() {
//        print("name:\(productName.text)")
//        print("Desc:\(productDiscription.text)")
//        print("state:\(productStatus.titleForSegment(at: productStatus.selectedSegmentIndex))")
//        print("price\(productPrice.text)")
//        print("sku\(sku.text)")
//        print("quna: \(productAvaliableQuantatiy.text)")
//        print("sizs\(productSizes)")
//        print("colors\(productColors)")
//        print("imgs\(producImgs)")
        
        let str:NSString = productAvaliableQuantatiy.text! as NSString
//        print("quna: \(str.intValue)")

        let parameters: [String: Any] = [
            "product": [
                "title": productName.text ?? "",
                "body_html": productDiscription.text ?? "",
                "vendor": productVendor.text ?? "",
                "product_type": productType.text ?? 0,
                "variants": [
                    [
                        "price": productPrice.text ?? "",
                        "sku": sku.text ?? "",
                        "inventory_quantity": str.integerValue ,
                        "option1": productSize.text ?? "",//productSizes[0],
                        "option2": productColor.text ?? "",//productColors[0],
                    ],
                ],
                "options": [
                    [
                        "name": "Size",
                        "position": 1,
                        "values": [productSize.text ?? ""],

                    ],
                    [
                        "name": "Color",
                        "position": 2,
                        "values": [productColor.text ?? ""],
                    ],
                ],
                "images": producImgs,
            ],
        ]
        productVM?.putProduct(target: .productByID(id: product?.id ?? 0), parameters: parameters)
        productVM?.bindResponseToVC = {
            DispatchQueue.main.async {
                switch self.productVM?.response?.keys.formatted() {
                case "product":
                    self.showAlert(title: "Success", msg: "Edited Successfully")
                    print(self.productVM?.response?["product"] ?? "")
                case "errors":
                    var errorMessages = ""

                    if let errors = self.productVM?.response?["errors"] as? [String: Any] {
                        for (field, messages) in errors {
                            errorMessages += "\(field.capitalized): "
                            if let messages = messages as? [String] {
                                for message in messages {
                                    errorMessages += " \(message)\n"
                                }
                            }
                        }
                    }
                    self.showAlert(title: "Error", msg: errorMessages)
                default:
                    print("done")
                }
            }
        }
    }
}

// MARK: Collection View
extension ProductDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return producImgs.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productImg", for: indexPath) as! ProductImage
        cell.productImg.kf.setImage(with: URL(string: producImgs[indexPath.row]["src"] as! String))
 
      return cell
    }
    
}
