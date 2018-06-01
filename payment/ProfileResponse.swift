//
//  ProfileResponse.swift
//  payment
//
//  Created by Pakgon on 7/13/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import ObjectMapper

class ProfileResponse: Mappable {
    var result: ProfileResult?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["Result"]
    }
}

class ProfileResult: Mappable {
    var accountKey: String?
    var accountNo: String?
    var balance: String?
    var customer: ProfileCustomer?
    var transaction: [ProfileTransaction]?
    var symbolLeft: String?
    var symbolRight: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        accountKey <- map["account_key"]
        accountNo <- map["account_no"]
        balance <- map["balance"]
        customer <- map["Customer"]
        transaction <- map["Transaction"]
        symbolLeft <- map["symbol_left"]
        symbolRight <- map["symbol_right"]
        
    }
}

class ProfileCustomer: Mappable {
    var customerKey: String?
    var firstName: String?
    var lastName: String?
    var phone: String?
    var img: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        customerKey <- map["customer_key"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        phone <- map["telephone"]
        img <- map["image_path"]
    }
}

class ProfileTransaction: Mappable {
    var transactionID: String?
    var transactionDate: String?
    var transactionTime: String?
    var transactionType: String?
    var accountDebit: String?
    var accountCredit: String?
    var credit: String?
    var debit: String?
    var balance: String?
    var symbol: String?
    var firstName: String?
    var lastName: String?
    var phone: String?
    var img: String?
    var dateAgo: String?
    var symbolLeft: String?
    var symbolRight: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        transactionID <- map["transaction_id"]
        transactionDate <- map["transaction_date"]
        transactionTime <- map["transaction_time"]
        transactionType <- map["transaction_type"]
        accountDebit <- map["account_debit"]
        accountCredit <- map["account_credit"]
        credit <- map["credit"]
        debit <- map["debit"]
        balance <- map["balance"]
        symbol <- map["symbol"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        phone <- map["telephone"]
        img <- map["image_path"]
        dateAgo <- map["date_ago"]
        symbolLeft <- map["symbol_left"]
        symbolRight <- map["symbol_right"]
    }
}
