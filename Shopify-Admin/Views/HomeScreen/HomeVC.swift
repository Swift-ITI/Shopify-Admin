//
//  ViewController.swift
//  Shopify-Admin
//
//  Created by Adham Samer on 27/02/2023.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet var inventoryCV: UICollectionView! {
        didSet {
            renderCVs(CV: inventoryCV, cellFile: "InventoryCVCell", cellID: "inventoryCell")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellInit(CV: inventoryCV, cellID: "inventoryCell", index: indexPath) as! InventoryCVCell
        cell.productImage.image = UIImage(named: "Shoe")
        cell.nameLabel.text = "Adidasssssssssssssssssssssss"
        cell.typeLabel.text = "tshirts"
        cell.quantityBtn.addTarget(self, action: #selector(goToDetails), for: .touchUpInside)
        
        cell.skuLabel.text = "SKU:4785961161619826231841"
        return cell
    }
    @objc func goToDetails(_ sender: Any){
        
    }
}

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
    
    
}
