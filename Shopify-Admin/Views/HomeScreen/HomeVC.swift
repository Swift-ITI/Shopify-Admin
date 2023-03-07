//
//  ViewController.swift
//  Shopify-Admin
//
//  Created by Adham Samer on 27/02/2023.
//
import Kingfisher
import UIKit

class HomeVC: UIViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var inventoryCV: UICollectionView! {
        didSet {
            renderCVs(CV: inventoryCV, cellFile: "InventoryCVCell", cellID: "inventoryCell")
//            inventoryCV.delegate = self
//            inventoryCV.dataSource = self
//            let nib = UINib(nibName: "InventoryCVCell", bundle: nil)
//            inventoryCV.register(nib, forCellWithReuseIdentifier: "inventoryCell")
        }
    }
    var viewModel = ViewModel()
    var products:[Product]?
    var searchProducts:[Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        viewModel.fetchData(target: .allProducts)
        viewModel.bindProductsToInventoryVC = { () in
            self.renderProducts()
            indicator.stopAnimating()
        }
        inventoryCV.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
//        viewModel.bindProductsToInventoryVC = { () in
//            self.renderProducts()
//            self.indicator.stopAnimating()
//        }
        inventoryCV.reloadData()
    }
    @IBAction func addNewProduct(_ sender: Any) {
        let invDetail = self.storyboard?.instantiateViewController(withIdentifier: "inventoryDetails") as! ProductDetailsVC
        invDetail.flag = 1
        self.navigationController?.pushViewController(invDetail, animated: true)
    }
}

// MARK: Collection View
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellInit(CV: inventoryCV, cellID: "inventoryCell", index: indexPath) as! InventoryCVCell
        let tmp = products?[indexPath.row]
        cell.productImage.kf.setImage(with: URL(string: tmp?.image?.src ?? ""))
        cell.nameLabel.text = tmp?.title
        cell.typeLabel.text = tmp?.product_type
        cell.qtnLabel.text = tmp?.variants?.first?.inventory_quantity.formatted()
        cell.skuLabel.text = "SKU: \(tmp?.variants?.first?.sku ?? "")"
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let invDetail = self.storyboard?.instantiateViewController(withIdentifier: "inventoryDetails") as! ProductDetailsVC
        invDetail.flag = 2
        invDetail.product = products?[indexPath.row]
        self.navigationController?.pushViewController(invDetail, animated: true)
    }
}


// MARK: Rendering
extension HomeVC {
    func renderCVs(CV: UICollectionView, cellFile: String, cellID: String) {
        CV.delegate = self
        CV.dataSource = self
        let nib = UINib(nibName: cellFile, bundle: nil)
        CV.register(nib, forCellWithReuseIdentifier: cellID)
    }

    func cellInit(CV: UICollectionView, cellID: String, index: IndexPath) -> UICollectionViewCell {
        let cell = CV.dequeueReusableCell(withReuseIdentifier: cellID, for: index)
        return cell
    }
    
    func renderProducts(){
        DispatchQueue.main.async {
            self.products = self.viewModel.products.products
            self.searchProducts = self.viewModel.products.products
            self.inventoryCV.reloadData()
        }
    }
}


extension HomeVC :UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        products = []
        if searchText == ""{
            products = searchProducts
        }
        for product in searchProducts ?? [] {
            if product.title.lowercased().contains(searchText.lowercased()){
                products?.append(product)
            }
        }
        self.inventoryCV.reloadData()
    }
}
