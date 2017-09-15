//
//  RegisterResponse.swift
//  payment
//
//  Created by Pakgon on 8/30/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

class RegisterResponse: Mappable {
    var result: RegisterResult?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
    }
}

class RegisterResult: Mappable {
    var success: String?
    var error: String?
    var data: RegisterData?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        success <- map["Success"]
        error <- map["Error"]
        data <- map["Data"]
    }
}

class RegisterData: Mappable {
    var code:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code <- map["secure_code"]
    }
}
