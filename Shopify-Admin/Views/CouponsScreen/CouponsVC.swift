//
//  CouponsVC.swift
//  Shopify-Admin
//
//  Created by Zeinab on 04/03/2023.
//

import UIKit

class CouponsVC: UIViewController {
    @IBOutlet var priceRuleId: UILabel!
    @IBOutlet var priceRuleValue: UILabel!
    @IBOutlet var priceRuleAvaialability: UILabel!
    @IBOutlet var priceRuleTargetType: UILabel!
    @IBOutlet var newCouponCode: UITextField!
    @IBOutlet var discountCodesTableView: UITableView! {
        didSet {
            discountCodesTableView.delegate = self
            discountCodesTableView.dataSource = self
            let nib = UINib(nibName: "CouponCV", bundle: nil)
            discountCodesTableView.register(nib, forCellReuseIdentifier: "couponCell")
        }
    }

    var priceRuleViewModel: PriceRuleViewModel?
    var priceRule: PriceRuleResult?
    var discountCodeViewModel: DiscountCodesViewModel?
    var discountCodes: DiscountCodes?
    var arrOfDiscountCodes : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        priceRuleViewModel = PriceRuleViewModel()
        discountCodeViewModel = DiscountCodesViewModel()
        priceRuleViewModel?.fetchData(target: .priceRule)
        priceRuleViewModel?.bindPriceRuleToCouponsVC = { () in
            DispatchQueue.main.async {
                self.priceRule = self.priceRuleViewModel?.priceRule

                self.priceRuleId.text = String(self.priceRule?.price_rules.first?.id ?? 0)
                self.priceRuleValue.text = self.priceRule?.price_rules.first?.value
                self.priceRuleAvaialability.text = "\(self.priceRule?.price_rules.first?.customer_selection ?? "No") customers"
                self.priceRuleTargetType.text = self.priceRule?.price_rules.first?.target_type

                self.discountCodeViewModel?.fetchData(target: .discountCodes(id: String(self.priceRule?.price_rules.first?.id ?? 0)))
            }
        }
        // id = 1380100899094

        discountCodeViewModel?.bindDiscountCodesToCouponsVC = { () in
            DispatchQueue.main.async {
                self.discountCodes = self.discountCodeViewModel?.discountCodes
                
                for code in self.discountCodes!.discount_codes {
                    self.arrOfDiscountCodes.append(code.code)
                }
                self.discountCodesTableView.reloadData()
            }
        }
    }

    @IBAction func AddNewCoupon(_ sender: Any) {
        if newCouponCode.text == "" {
            showAlert()
        } else {
            let parameters: [String: Any] =
                [
                    "discount_code":
                        [
                            "code": newCouponCode.text,
                        ],
                ]
            // discountCodes?.discount_codes
            discountCodeViewModel?.postData(target: .discountCodes(id: String(priceRule?.price_rules.first?.id ?? 0)), parameter: parameters)

            arrOfDiscountCodes.append(newCouponCode.text ?? "")
            discountCodesTableView.reloadData()
        }

        // let parameters: [String : Any] = ["discount_code" : ["code":"Zeinab2000","usage_count":0]]
    }

    func showAlert() {
        let alert = UIAlertController(title: "incomplete data", message: "Enter full data", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}

extension CouponsVC: UITableViewDelegate {
}

extension CouponsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        view.addSubview(indicator)
        
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this code?", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
                indicator.startAnimating()
                self.discountCodeViewModel?.deleteCode(target: .deleteCodeByID(ruleID: self.priceRule?.price_rules.first?.id ?? 0, codeID: self.discountCodes?.discount_codes[indexPath.row].id ?? 0))
                
                self.discountCodes?.discount_codes.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
                indicator.stopAnimating()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))

            present(alert, animated: true, completion: nil)
            
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfDiscountCodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CouponCV = tableView.dequeueReusableCell(withIdentifier: "couponCell", for: indexPath) as! CouponCV
        cell.discountCode.text = arrOfDiscountCodes[indexPath.row]
        //cell.discountCode.text = discountCodes?.discount_codes[indexPath.row].code
       // cell.discountUsage.text = String(discountCodes?.discount_codes[indexPath.row].usage_count ?? 0)

        return cell
    }

    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
