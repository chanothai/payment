//
//  ResponseAccount.swift
//  payment
//
//  Created by Pakgon on 9/26/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

class ResponseAccount: Mappable{
    var result: ResultAccount?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["Result"]
    }
}

class ResultAccount: Mappable {
    var code:String?
    var description:String?
    var accountNo:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        description <- map["description"]
        accountNo <- map["account_no"]
    }
}
