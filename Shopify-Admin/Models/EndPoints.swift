//
//  EndPoints.swift
//  Shopify-Admin
//
//  Created by Adham Samer on 02/03/2023.
//

import Foundation
var BaseUrl = "https://29f36923749f191f42aa83c96e5786c5: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@ios-q2-new-capital-admin-2022-2023.myshopify.com/admin/api/2023-01"

enum EndPoints {
    case allProducts
    case productByID(id: Int)
    case catigoriesProducts(id: Int)
    case shoes(id: Int) // "SHOES"
    case accessories(id: Int) // "ACCESSORIES"
    case tshirts(id: Int) // "T-SHIRTS"
    case priceRule
    case discountCodes(id: String)
    case deleteCodeByID(ruleID: Int, codeID: Int)
    case deleteProductByID(productID: Int)
    case customers
    case setInventory
    case collect
    case removeFromCollect(id: Int)
    var path: String {
        switch self {
        case .allProducts:
            return "\(BaseUrl)/products.json"
        case let .productByID(id: id):
            return "\(BaseUrl)/products/\(id).json"
        case let .catigoriesProducts(id: id):
            return "\(BaseUrl)/products.json?collection_id=\(id)"
        case let .shoes(id: id):
            return "\(BaseUrl)/products.json?collection_id=\(id)&product_type=SHOES"
        case let .accessories(id: id):
            return "\(BaseUrl)/products.json?collection_id=\(id)&product_type=ACCESSORIES"
        case let .tshirts(id: id):
            return "\(BaseUrl)/products.json?collection_id=\(id)&product_type=T-SHIRTS"
        case .priceRule:
            return "\(BaseUrl)/price_rules.json"
        case let .discountCodes(id: id):
            return "\(BaseUrl)/price_rules/\(id)/discount_codes.json"

        case let .deleteCodeByID(ruleID: ruleID, codeID: codeID):
            return "\(BaseUrl)/price_rules/\(ruleID)/discount_codes/\(codeID).json"
        case .customers:
            return "\(BaseUrl)/customers.json"

        case let .deleteProductByID(productID: id):
            return "\(BaseUrl)/products/\(id).json"
        case .setInventory:
            return "\(BaseUrl)/inventory_levels/set.json"
        case .collect:
            return "\(BaseUrl)/collects.json"
        case let .removeFromCollect(id: id):
            return "\(BaseUrl)/collects/\(id).json"
        }
    }
}

enum CatigoryID {
    case homePage
    case kids
    case men
    case sale
    case women

    var id: Int {
        switch self {
        case .homePage:
            return 436748681494
        case .kids:
            return 436751368470
        case .men:
            return 436751270166
        case .sale:
            return 436751401238
        case .women:
            return 436751335702
        }
    }
}
