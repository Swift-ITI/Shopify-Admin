//
//  ViewModel.swift
//  Shopify-Admin
//
//  Created by Adham Samer on 27/02/2023.
//

import Foundation
class ViewModel {
    var bindProductsToInventoryVC: ( ()->() ) = {}
    var products:Products! {
        didSet{
            bindProductsToInventoryVC()
        }
       
    }
    func fetchData(target : EndPoints) {
        NetworkServices.fetch(url: target.path) { result in
            self.products = result
        }
    }
}

class PriceRuleViewModel {
    var bindPriceRuleToCouponsVC: ( ()->() ) = {}
    var priceRule:PriceRuleResult! {
        didSet{
            bindPriceRuleToCouponsVC()
        }
       
    }
    func fetchData(target : EndPoints) {
        NetworkServices.fetch(url: target.path) { result in
            self.priceRule = result
        }
    }
}

class DiscountCodesViewModel {
    var bindDiscountCodesToCouponsVC: ( ()->() ) = {}
    var discountCodes:DiscountCodes! {
        didSet{
            bindDiscountCodesToCouponsVC()
        }
       
    }
    func fetchData(target : EndPoints) {
        NetworkServices.fetch(url: target.path) { result in
            self.discountCodes = result
        }
    }
    
    func postData(target : EndPoints , parameter : [String : Any]) {
        
        NetworkServices.postMethod(url: target.path, parameters: parameter)
    }
}
