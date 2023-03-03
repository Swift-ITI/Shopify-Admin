//
//  NetworkServices.swift
//  Shopify-Admin
//
//  Created by Adham Samer on 27/02/2023.
//

import Foundation
import Alamofire
protocol APIservices
{
    static func fetch <T : Decodable>(url:String?,compiletionHandler : @escaping (T?)->Void)
    
    static func postMethod(url : String , parameters : [String : Any])
}

class NetworkServices : APIservices
{
    static func fetch<T>(url: String?, compiletionHandler: @escaping (T?) -> Void) where T : Decodable {
        let request = AF.request(url ?? "")
        
        request.responseDecodable(of:T.self) { (response) in
            guard let resultOfAPI = response.value else {
                
                compiletionHandler(nil)
                return }
            compiletionHandler(resultOfAPI)
        }
    }
    
    static func postMethod(url : String , parameters : [String : Any]) {
        
        guard let url = URL(string: url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        print(parameters)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data , options: .allowFragments)
                
                print("SUCEES:\(response)")
            }
            catch {
                print(error)
            }
        }.resume()
        
    }
}
