//
//  ModelCart.swift
//  payment
//
//  Created by Pakgon on 4/25/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

class ModelCart {
    static var me:ModelCart?
    var information:InformationUser?
    var manageModel: ManageModel?
    
    init() {
        information = InformationUser()
        manageModel = ManageModel()
    }
    
    static func getInstance() -> ModelCart {
        if me == nil {
            me = ModelCart()
        }
        return me!
    }
    
    
    func getModel() -> ManageModel {
        return manageModel!
    }
    
    var getInformation:InformationUser {
        get {
            return information!
        }
        
        set {
            information = newValue
        }
    }
}

class ManageModel {
    var _profileResponse: ProfileResult?
    
    var profileresponse: ProfileResult {
        get {
            return _profileResponse!
        }
        
        set {
            _profileResponse = newValue
        }
    }
}


