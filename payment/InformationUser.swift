//
//  InformationUser.swift
//  payment
//
//  Created by Pakgon on 4/21/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

class InformationUser {
    var _accountNo:String?
    var _balance:String?
    var _amount:String?
    var _token:String?
    var _transactionRef:String?
    var _type:String?
    var _cardCode:String?
    
    var account:String {
        get {
            return _accountNo!
        }
        set {
            _accountNo = newValue
        }
    }
    
    var balance:String {
        get {
            return _balance!
        }
        set {
            _balance = newValue
        }
    }
    
    var amount:String {
        get {
            return _amount!
        }
        set {
            _amount = newValue
        }
    }
    
    var token:String {
        get {
            return _token!
        }
        set {
            _token = newValue
        }
    }
    
    var transactionRef:String {
        get {
            return _transactionRef!
        }
        set {
            _transactionRef = newValue
        }
    }

    var type:String {
        get {
            return _type!
        }
        set {
            _type = newValue
        }
    }
    
    var cardCode:String {
        get {
            return _cardCode!
        }
        set {
            _cardCode = newValue
        }
    }
    
}
