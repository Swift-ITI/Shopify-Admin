//
//  CouponCV.swift
//  Shopify-Admin
//
//  Created by Zeinab on 04/03/2023.
//

import UIKit

class CouponCV: UITableViewCell {

    @IBOutlet weak var discountCode: UILabel!
    @IBOutlet weak var discountUsage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
