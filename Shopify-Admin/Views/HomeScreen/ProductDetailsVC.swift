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

    @IBOutlet var productName: UITextField!
    @IBOutlet var productDiscription: UITextView!
    @IBOutlet var productPrice: UITextField!
    @IBOutlet var productImgURL: UITextField!
    @IBOutlet var ProductImagesTableView: UITableView! {
        didSet {
            // ProductImagesTableView.layer.borderWidth = 2
        }
    }

    @IBOutlet var productCollection: UILabel!
    @IBOutlet var pollDownProductCollection: UIButton!
    @IBOutlet var productType: UILabel!
    @IBOutlet var pollDownProductType: UIButton!
    @IBOutlet var productSize: UITextField!
    @IBOutlet var productColor: UITextField!
    @IBOutlet var productSizeTableView: UITableView! {
        didSet {
            // productSizeTableView.layer.borderWidth = 2
        }
    }

    @IBOutlet var productColorTableView: UITableView! {
        didSet {
            // productColorTableView.layer.borderWidth = 2
        }
    }

    @IBOutlet var productAvaliableQuantatiy: UILabel!
    @IBOutlet var productAvaliableManually: UITextField!
    @IBOutlet var sku: UITextField! {
        didSet {
            sku.layer.borderWidth = 2
            sku.layer.borderColor = UIColor(named: "SecondaryColor")?.cgColor
            sku.layer.cornerRadius = 10
        }
    }

    @IBOutlet var minusQuantatity: UIButton!
    @IBOutlet var productStatus: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        productVM = ViewModel()

        product?.images?.forEach({ img in
            self.producImgs.append(["src": img.src])
            // self.producImgs.append(img.src)
        })

        productSizes = (product?.options?[0].values) ?? []
        productColors = (product?.options?[1].values) ?? []

        productName.text = product?.title
        productDiscription.text = product?.body_html
        productPrice.text = product?.variants?[0].price
        productAvaliableQuantatiy.text = String(product?.variants?[0].inventory_quantity ?? 0)
        sku.text = product?.variants?[0].sku
        // productCollection.text = product?
        productType.text = product?.product_type

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
            ProductImagesTableView.reloadData()

        } else {
            showAlert(title: "Failed", msg: "Add Img")
        }
    }

    @IBAction func addProductSize(_ sender: Any) {
        if productSize.text != "" {
            productSizes.append(productSize.text ?? "")
            productSizeTableView.reloadData()

        } else {
            showAlert(title: "Failed", msg: "Add Size")
        }
    }

    @IBAction func addProductColor(_ sender: Any) {
        if productColor.text != "" {
            productColors.append(productColor.text ?? "")
            productColorTableView.reloadData()

        } else {
            showAlert(title: "Failed", msg: "Add Color")
        }
    }

    @IBAction func minusProductQuantatityByOne(_ sender: Any) {
        if (Int(productAvaliableQuantatiy.text ?? "") ?? 0) == 1 {
            minusQuantatity.isUserInteractionEnabled = false
        }
        productAvaliableQuantatiy.text = String((Int(productAvaliableQuantatiy.text ?? "") ?? 0) - 1)
    }

    @IBAction func plusProductQuantatityByOne(_ sender: Any) {
        productAvaliableQuantatiy.text = String((Int(productAvaliableQuantatiy.text ?? "") ?? 0) + 1)
    }

    @IBAction func saveProduct(_ sender: Any) {
        switch flag {
        case 1:
            postData()
            break
        case 2: // update to API
            putData()
        default: break
        }
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

        case .none:
            print("Noe")
        case .some:
            print("Yes")
        }
    }

    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)

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

extension ProductDetailsVC: UITableViewDelegate {}
extension ProductDetailsVC: UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.layer.borderWidth = 2

        switch tableView {
        case ProductImagesTableView:

            // cell.image.kf.setImage(with: URL(string: product?.images?[indexPath.row].src ?? ""))
            cell.textLabel?.text = producImgs[indexPath.row]["src"] as? String

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

// MARK: POST

extension ProductDetailsVC {
    func postData() {
        let parameters: [String: Any] = [
            "product": [
                "title": productName.text ?? "",
                "body_html": productDiscription.text ?? "",
                "vendor": "ADIDAS",
                "status": productStatus.titleForSegment(at: productStatus.selectedSegmentIndex) ?? "",
                "variants": [
                    [
                        "price": productPrice.text ?? "",
                        "sku": sku.text ?? "",
                        "inventory_quantity": productAvaliableQuantatiy.text ?? "",
                        "option1": productSizes[0],
                        "option2": productColors[0],
                    ],
                ],
                "options": [
                    [
                        "name": "Size",
                        "position": 1,
                        "values": productSizes,

                    ],
                    [
                        "name": "Color",
                        "position": 2,
                        "values": productColors,
                    ],
                ],
                "images": producImgs,
            ],
        ]
        productVM?.postProduct(target: .allProducts, parameters: parameters)
        showAlert(title: "Done", msg: "Added Successfully")
    }

    func putData() {
        let str:NSString = productAvaliableQuantatiy.text! as NSString
        let parameters: [String: Any] = [
            "product": [
                "title": productName.text ?? "",
                "body_html": productDiscription.text ?? "",
                "vendor": "ADIDAS",
                "status": productStatus.titleForSegment(at: productStatus.selectedSegmentIndex) ?? "",
                "variants": [
                    [
                        "price": productPrice.text ?? "",
                        "sku": sku.text ?? "",
                        "inventory_quantity": str.integerValue ,
                        "option1": productSizes[0],
                        "option2": productColors[0],
                    ],
                ],
                "options": [
                    [
                        "name": "Size",
                        "position": 1,
                        "values": productSizes,

                    ],
                    [
                        "name": "Color",
                        "position": 2,
                        "values": productColors,
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
                    self.showAlert(title: "Success", msg: "Edited Successfullt")
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
