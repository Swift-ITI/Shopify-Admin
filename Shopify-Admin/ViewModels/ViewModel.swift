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
