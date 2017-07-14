//
//  SellerResponse.swift
//  payment
//
//  Created by Pakgon on 7/14/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

class SellerResponse: Mappable {
    var result: SellerResult?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["Result"]
    }
}

class SellerResult: Mappable {
    var token: String?
    var tranRef: String?
    var amount: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token <- map["token"]
        tranRef <- map["transaction_ref"]
        amount <- map["amount"]
    }
}
