//
//  CustomersVC.swift
//  Shopify-Admin
//
//  Created by Zeinab on 04/03/2023.
//

import UIKit

class CustomersVC: UIViewController {

    @IBOutlet weak var customernumbers: UILabel!
    @IBOutlet weak var customersTableView: UITableView!
    
    var customerViewModel : CustomerViewModel?
    var customers : Customers?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customerViewModel = CustomerViewModel()
        customerViewModel?.fetchData(target: .customers)
        customerViewModel?.bindcustomersToCustomersVC = {() in
            self.customers = self.customerViewModel?.customers
            
            self.customernumbers.text = (self.customers?.customers.count ?? 0).formatted()
            self.customersTableView.reloadData()
        }
    }
}

extension CustomersVC : UITableViewDelegate {}
extension CustomersVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers?.customers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = customers?.customers[indexPath.row].email
        cell.detailTextLabel?.text = customers?.customers[indexPath.row].phone
        
        return cell
    }
}
