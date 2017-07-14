//
//  BuyerResponse.swift
//  payment
//
//  Created by Pakgon on 7/14/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

class BuyerResponse: Mappable {
    var result: BuyerResult?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["Result"]
    }
}

class BuyerResult: Mappable {
    var tranRef: String?
    var code: String?
    var descryption: String?
    var balanceDebit: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        tranRef <- map["transaction_ref"]
        code <- map["code"]
        descryption <- map["description"]
        balanceDebit <- map["balance_debit"]
    }
}
