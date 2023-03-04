//
//  DiscountCodes.swift
//  Shopify-Admin
//
//  Created by Zeinab on 04/03/2023.
//

import Foundation
class DiscountCodes : Decodable {
    var discount_codes : [DiscountCode]
}

class DiscountCode : Decodable {
    var id : Int
    var price_rule_id : Int
    var code : String
    var usage_count : Int?
}
