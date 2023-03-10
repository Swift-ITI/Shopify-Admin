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
    var product_collection: String = ""

    @IBOutlet var imgCollectionView: UICollectionView! { didSet {
        imgCollectionView.delegate = self
        imgCollectionView.dataSource = self
        imgCollectionView.layer.borderWidth = 2
        imgCollectionView.layer.borderColor = UIColor(named: "SecondaryColor")?.cgColor
        imgCollectionView.layer.cornerRadius = 20

    }}
    @IBOutlet var productVendor: UITextField!
    @IBOutlet var save_editBtn: UIButton!
    @IBOutlet var productName: UITextField!
    @IBOutlet var productDiscription: UITextView! {
        didSet {
            productDiscription.layer.cornerRadius = 10
            productDiscription.layer.borderColor = UIColor(named: "SecondaryColor")?.cgColor
            productDiscription.layer.borderWidth = 1.5
        }
    }
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
    @IBOutlet var sku: UITextField!
    @IBOutlet var deleteBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        renderTxtFields(txtFields: [productName, productPrice, productVendor, productImgURL, productSize, productColor, productAvaliableManually, sku])
        switch flag {
        case 1:
            deleteBtn.isHidden = true
            save_editBtn.setTitle("Save", for: .normal)
        case 2:
            save_editBtn.setTitle("Edit", for: .normal)
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
            imgCollectionView.reloadData()
            // reload collction view data
        } else {
            showAlert(title: "Failed", msg: "Add Image") { _ in }
        }
    }

    @IBAction func saveProduct(_ sender: Any) {
        if productName.text != "" && productDiscription.text != "" && productPrice.text != "" && productCollection.text != "" && productType.text != "" && sku.text != "" && !(producImgs.isEmpty && productSizes.isEmpty && productColors.isEmpty) {
            switch flag {
            case 1: // New to API
                postData()
                break
            case 2: // Update to API
                putData()
            default: break
            }
        } else {
            showAlert(title: "Missing Data", msg: "Please enter all fields") { _ in }
        }
    }

// MARK: DELETE
    @IBAction func deleteProduct(_ sender: Any) {
        switch flag {
        case 1:
            showAlert(title: "Failed", msg: "Can't delete", handler: { _ in })
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

}

// MARK: POST

extension ProductDetailsVC {
    func postData() {
        
        let parameters: [String: Any] = [
            "product": [
                "title": productName.text!,
                "body_html": productDiscription.text!,
                "vendor": productVendor.text!,
                "product_type": productType.text!,
                "variants": [
                    [
                        "price": productPrice.text!,
                        "sku": sku.text!,
                        "inventory_management":"shopify",
                        // "position": 1,
                        //"inventory_quantity": productAvaliableQuantatiy.text!,
                        "option1": productSize.text!, // productSizes[0],
                        "option2": productColor.text!, // productColors[0],
                    ],
                ],
                "options": [
                    [
                        "name": "Size",
                        "position": 1,
                        "values": [productSize.text!],
                    ],
                    [
                        "name": "Color",
                        "position": 2,
                        "values": [productColor.text!],
                    ],
                ],
                "images": producImgs,
            ],
        ]
        switch product_collection {
        case "All":
            productVM?.postProduct(target: .allProducts, parameters: parameters)
        case "Kids":
            productVM?.postProduct(target: .catigoriesProducts(id: CatigoryID.kids.id), parameters: parameters)
        case "Men":
            productVM?.postProduct(target: .catigoriesProducts(id: CatigoryID.men.id), parameters: parameters)
        case "Sale":
            productVM?.postProduct(target: .catigoriesProducts(id: CatigoryID.sale.id), parameters: parameters)
        case "Women":
            productVM?.postProduct(target: .catigoriesProducts(id: CatigoryID.women.id), parameters: parameters)
        default:
            showAlert(title: "Oh ..))", msg: "Please try again", handler: { _ in })
        }

        showAlert(title: "Done", msg: "Added Successfully", handler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
    }

// MARK: PUT
    func putData() {
        
        let parameters: [String: Any] = [
            "product": [
                "title": productName.text!,
                "body_html": productDiscription.text!,
                "vendor": productVendor.text!,
                "product_type": productType.text!,
                "variants": [
                    [
                        "price": productPrice.text!,
                        "sku": sku.text!,
                        "option1": productSize.text!, // productSizes[0],
                        "option2": productColor.text!, // productColors[0],
                    ],
                ],
                "options": [
                    [
                        "name": "Size",
                        "position": 1,
                        "values": [productSize.text!],

                    ],
                    [
                        "name": "Color",
                        "position": 2,
                        "values": [productColor.text!],
                    ],
                ],
                "images": producImgs,
            ],
        ]
        
        let invParams: [String : Any] = [
            "location_id":78795800854,
            "inventory_item_id":product?.variants?.first?.inventory_item_id ?? 0,
            "available":productAvaliableManually.text?.codingKey.intValue ?? 0
            
        ]
        switch product_collection {
        case "All":
            productVM?.putProduct(target: .productByID(id: product?.id ?? 0), parameters: parameters)
        case "Kids":
            productVM?.putProduct(target: .catigoriesProducts(id: CatigoryID.kids.id), parameters: parameters)
        case "Men":
            productVM?.putProduct(target: .catigoriesProducts(id: CatigoryID.men.id), parameters: parameters)
        case "Sale":
            productVM?.putProduct(target: .catigoriesProducts(id: CatigoryID.sale.id), parameters: parameters)
        case "Women":
            productVM?.putProduct(target: .catigoriesProducts(id: CatigoryID.women.id), parameters: parameters)
        default:
            showAlert(title: "Oh ..", msg: "Please try again", handler: { _ in })
        }
        productVM?.postProduct(target: .setInventory, parameters: invParams)
        productVM?.bindResponseToVC = {
            DispatchQueue.main.async {
                switch self.productVM?.response?.keys.formatted() {
                case "product":
                    self.showAlert(title: "Done", msg: "Edited Successfully", handler: { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
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
                    self.showAlert(title: "Error", msg: errorMessages, handler: { _ in })
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

// MARK: Rendering

extension ProductDetailsVC {
    func renderTxtFields(txtFields: [UITextField]) {
        for txtField in txtFields {
            txtField.layer.cornerRadius = 10
            txtField.layer.borderColor = UIColor(named: "SecondaryColor")?.cgColor
            txtField.layer.borderWidth = 1.5
        }
    }
    
    func showAlert(title: String, msg: String, handler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            handler(action)
        }))

        present(alert, animated: true, completion: nil)
    }
}
