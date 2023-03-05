//
//  PriceRule.swift
//  Shopify-Admin
//
//  Created by Zeinab on 04/03/2023.
//

import Foundation
class PriceRuleResult : Decodable {
    var price_rules : [priceRule]
}

class priceRule : Decodable {
    var id : Int
    var value_type : String
    var value : String?
    var customer_selection : String?
    var target_type : String?
    var once_per_customer : Bool?
    var usage_limit : String?
    var starts_at : String?
    var ends_at : String?
}
