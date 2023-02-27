//
//  ProductsVC.swift
//  Shopify-Admin
//
//  Created by Adham Samer on 27/02/2023.
//

import UIKit

class ProductsVC: UIViewController {

    @IBOutlet weak var productsCV: UICollectionView!{
        didSet{
            productsCV.delegate = self
            productsCV.dataSource = self
            let nib = UINib(nibName: "ProductCVCell", bundle: nil)
            productsCV.register(nib, forCellWithReuseIdentifier: "productCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ProductsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCVCell
        cell.productImage.image = UIImage(named: "Shoe")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetails = self.storyboard?.instantiateViewController(withIdentifier: "productDetailsVC") as! ProductDetailsVC
        self.navigationController?.pushViewController(productDetails, animated: true)
    }
    
}
