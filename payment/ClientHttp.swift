//
//  ClientHttp.swift
//  payment
//
//  Created by Pakgon on 7/13/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import Alamofire
import SwiftEventBus
import SwiftyJSON
import AlamofireObjectMapper

struct PathURL {
    static var urlServer = "e-payment.gconnect-th.com/"
    static var getToken = "e-money-client/Accounts/token"
    static var getProfile = "e-money-client/Accounts/profile"
    static var getTranref = "e-money-client/Sellers/QRcode"
    static var getPayment = "e-money-client/Buyers/QRcode"
}

class ClientHttp {
    let url: String?
    private static var me: ClientHttp?
    private let header: HTTPHeaders?
    
    init() {
        let https:String = "http://"
        self.url = "\(https)\(PathURL.urlServer)"
        header = ["Accept":"application/json"]
    }
    
    public static func getInstance() -> ClientHttp {
        if me == nil {
            me = ClientHttp()
        }
        
        return me!
    }
    
    func requestCode(){
        let path: String? = "http://connect03.pakgon.com/Api/getGenCode.json"
        guard let realUrl = URL(string: path!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseObject { (response: DataResponse<RegisterResponse>) in
            guard let codeResponse = response.result.value else {
                print(response.error!)
                return
            }
            
            SwiftEventBus.post("RegisterResponse", sender: codeResponse.result)
        }
    }
    
    
    func requestRegister(parameter: [String: Any]) {
        let path: String? = "\(url!)e-money-client/Registers"
        guard let realUrl = URL(string: path!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseObject { (response: DataResponse<ResponseAccount>) in
            
            guard let registerResponse = response.result.value else {
                print(response.error!)
                return
            }
            
            SwiftEventBus.post("RegisterAccountResponse", sender: registerResponse.result)
        }
    }
    
    func requestToken(parameter: [String: String]) {
        let path: String? = "\(url!)\(PathURL.getToken)"
        print(path!)
        guard let realUrl = URL(string: path!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseObject { (response: DataResponse<AccountResponse>) in
            guard let accountResponse = response.result.value else {
                print(response.error!)
                return
            }
            
            SwiftEventBus.post("AccountResponse", sender: accountResponse.result)
        }
    }
    
    func requestProfile(parameter: [String: String]) {
        let path: String? = "\(url!)\(PathURL.getProfile)"
        print(path!)
        guard let realUrl = URL(string: path!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseObject { (response: DataResponse<ProfileResponse>) in
            guard let profileresponse = response.result.value else {
                print(response.error!)
                return
            }
            
            SwiftEventBus.post("ProfileResponse", sender: profileresponse.result)
        }
    }
    
    func requestTranref(parameter: [String: String]) {
        let path: String? = "\(url!)\(PathURL.getTranref)"
        print(path!)
        guard let realUrl = URL(string: path!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseObject { (response: DataResponse<SellerResponse>) in
            guard let sellerResponse = response.result.value else {
                print(response.error!)
                return
            }
            
            SwiftEventBus.post("SellerResponse", sender: sellerResponse.result)
        }
    }
    
    func payCash(parameter: [String: String]) {
        let path: String? = "\(url!)\(PathURL.getPayment)"
        print(path!)
        guard let realUrl = URL(string: path!) else {
            return
        }
        
        Alamofire.request(realUrl, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseObject { (response: DataResponse<BuyerResponse>) in
            guard let buyerResponse = response.result.value else {
                print(response.error!)
                return
            }
            
            SwiftEventBus.post("BuyerResponse", sender: buyerResponse.result)
        }
    }
}
