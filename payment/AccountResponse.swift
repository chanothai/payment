//
//  AccountResponse.swift
//  payment
//
//  Created by Pakgon on 7/13/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

class AccountResponse: Mappable {
    var result: AccountResult?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["Result"]
    }
}

class AccountResult: Mappable {
    var accountNo: String?
    var ip: String?
    var token: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        accountNo <- map["account_no"]
        ip <- map["ip"]
        token <- map["token"]
    }
}
