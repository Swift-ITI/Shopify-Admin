//
//  ViewModel.swift
//  Shopify-Admin
//
//  Created by Adham Samer on 27/02/2023.
//

import Foundation
//MARK: PRODUCT
class ViewModel {
    var bindProductsToInventoryVC: (() -> Void) = {}
    var bindResponseToVC: (() -> Void) = {}
    var products: Products! {
        didSet {
            bindProductsToInventoryVC()
        }
    }

    var response: [String: Any]? {
        didSet {
            bindResponseToVC()
        }
    }

    func fetchData(target: EndPoints) {
        NetworkServices.fetch(url: target.path) { result in
            self.products = result
        }
    }

    func deleteProduct(target: EndPoints) {
        NetworkServices.delete(url: target.path)
    }

    func postProduct(target: EndPoints, parameters: [String: Any]) {
        NetworkServices.postMethod(url: target.path, parameters: parameters) { response in
            self.response = response
        }
    }

    func putProduct(target: EndPoints, parameters: [String: Any]) {
        NetworkServices.putMethod(url: target.path, parameters: parameters) { response in
            self.response = response
        }
    }
}

//MARK: PRICE_RULE
class PriceRuleViewModel {
    var bindPriceRuleToCouponsVC: (() -> Void) = {}
    var priceRule: PriceRuleResult! {
        didSet {
            bindPriceRuleToCouponsVC()
        }
    }

    func fetchData(target: EndPoints) {
        NetworkServices.fetch(url: target.path) { result in
            self.priceRule = result
        }
    }
}

//MARK: DISCOUNTS
class DiscountCodesViewModel {
    var bindDiscountCodesToCouponsVC: (() -> Void) = {}
    var discountCodes: DiscountCodes? {
        didSet {
            bindDiscountCodesToCouponsVC()
        }
    }

    var response:[String:Any]? {
        didSet{
            bindDiscountCodesToCouponsVC()
        }
    }
    func fetchData(target: EndPoints) {
        NetworkServices.fetch(url: target.path) { result in
            self.discountCodes = result
        }
    }

    func postCoupon(target: EndPoints, parameter: [String: Any]) {
        NetworkServices.postMethod(url: target.path, parameters: parameter) {response in
            self.response = response
        }
    }

    func deleteCode(target: EndPoints) {
        NetworkServices.delete(url: target.path)
    }
}

//MARK: CUSTOMERS
class CustomerViewModel {
    var bindcustomersToCustomersVC: (() -> Void) = {}
    var customers: Customers! {
        didSet {
            bindcustomersToCustomersVC()
        }
    }

    func fetchData(target: EndPoints) {
        NetworkServices.fetch(url: target.path) { result in
            self.customers = result
        }
    }
}
