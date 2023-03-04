//
//  CouponsVC.swift
//  Shopify-Admin
//
//  Created by Zeinab on 04/03/2023.
//

import UIKit

class CouponsVC: UIViewController {
    
@IBOutlet weak var priceRuleId: UILabel!
@IBOutlet weak var priceRuleValue: UILabel!
@IBOutlet weak var priceRuleAvaialability: UILabel!
@IBOutlet weak var priceRuleTargetType: UILabel!
@IBOutlet weak var newCouponCode: UITextField!
    @IBOutlet weak var discountCodesTableView: UITableView! {
        didSet {
            discountCodesTableView.delegate = self
            discountCodesTableView.dataSource = self
            let nib = UINib(nibName: "CouponCV", bundle: nil)
            discountCodesTableView.register(nib, forCellReuseIdentifier:"couponCell")
        }
    }

var priceRuleViewModel : PriceRuleViewModel?
var priceRule : PriceRuleResult?
var discountCodeViewModel : DiscountCodesViewModel?
var discountCodes : DiscountCodes?
    var arrayCount : Int?

    

override func viewDidLoad() {
    super.viewDidLoad()
    
    priceRuleViewModel = PriceRuleViewModel()
    discountCodeViewModel = DiscountCodesViewModel()
    priceRuleViewModel?.fetchData(target: .priceRule)
    priceRuleViewModel?.bindPriceRuleToCouponsVC = {() in
        DispatchQueue.main.async {
            self.priceRule = self.priceRuleViewModel?.priceRule
            
            self.priceRuleId.text = String(self.priceRule?.price_rules.first?.id ?? 0)
            self.priceRuleValue.text = self.priceRule?.price_rules.first?.value
            self.priceRuleAvaialability.text = ("\(self.priceRule?.price_rules.first?.customer_selection ?? "No") customers")
            self.priceRuleTargetType.text = self.priceRule?.price_rules.first?.target_type
           
            self.discountCodeViewModel?.fetchData(target: .discountCodes(id: String(self.priceRule?.price_rules.first?.id ?? 0)))
            self.arrayCount = self.discountCodes?.discount_codes.count ?? 0
        }
    }
    //id = 1380100899094
    
    
    discountCodeViewModel?.bindDiscountCodesToCouponsVC = {() in
        DispatchQueue.main.async {
            self.discountCodes = self.discountCodeViewModel?.discountCodes
            self.discountCodesTableView.reloadData()
        }
       
    }
}

@IBAction func AddNewCoupon(_ sender: Any) {
    if newCouponCode.text == "" {
        showAlert()
    } else
    {
        let parameters: [String : Any] =
        [
            "discount_code" :
                [
                "code":newCouponCode.text
                ]
            ]
        //discountCodes?.discount_codes
        discountCodeViewModel?.postData(target: .discountCodes(id: String(self.priceRule?.price_rules.first?.id ?? 0)), parameter: parameters)
        
        discountCodes?.discount_codes[arrayCount ?? 0].code = newCouponCode.text ?? ""
        self.discountCodesTableView.reloadData()
        
    }
    
    //let parameters: [String : Any] = ["discount_code" : ["code":"Zeinab2000","usage_count":0]]
}
    
    func showAlert() {
        let alert = UIAlertController(title: "incomplete data", message: "Enter full data", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        present(alert, animated: true, completion: nil)
    }

}
extension CouponsVC : UITableViewDelegate {}
extension CouponsVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discountCodes?.discount_codes.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CouponCV = tableView.dequeueReusableCell(withIdentifier: "couponCell", for: indexPath) as! CouponCV
        cell.discountCode.text = discountCodes?.discount_codes[indexPath.row].code
        cell.discountUsage.text = String(discountCodes?.discount_codes[indexPath.row].usage_count ?? 0)
        

        return cell
    }
}
