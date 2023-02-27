//
//  ProductCVCell.swift
//  Shopify-Admin
//
//  Created by Adham Samer on 27/02/2023.
//

import UIKit

class ProductCVCell: UICollectionViewCell {

    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        renderCell(View:self)
        // Initialization code
    }
    func renderCell(View:UICollectionViewCell){
        View.layer.cornerRadius = 20
        View.layer.borderColor = UIColor(named: "SecondaryColor")?.cgColor
        View.layer.borderWidth = 2
    }

}
