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
    case catigoriesProducts (id : String)
    case shoes (id : String) //"SHOES"
    case accessories (id : String) //"ACCESSORIES"
    case tshirts (id : String) //"T-SHIRTS"
    var path : String {
        switch self{
        case .allProducts:
            return "\(BaseUrl)/products.json"
        case .catigoriesProducts (id : let id) :
            return "\(BaseUrl)/products.json?collection_id=\(id)"
        case .shoes (id : let id):
            return "\(BaseUrl)/products.json?collection_id=\(id)&product_type=SHOES"
        case .accessories (id : let id):
            return "\(BaseUrl)/products.json?collection_id=\(id)&product_type=ACCESSORIES"
        case .tshirts (id : let id):
            return "\(BaseUrl)/products.json?collection_id=\(id)&product_type=T-SHIRTS"
        }
    }
    
}

enum CatigoryID {
    case homePage
    case kids
    case men
    case sale
    case women
    
    var id : String {
        switch self {
        case .homePage:
            return "436748681494"
        case .kids:
            return "436751368470"
        case .men:
            return "436751270166"
        case .sale:
            return "436751401238"
        case .women:
            return "436751335702"
        }
    }
}
