//
//  AuthenStore.swift
//  payment
//
//  Created by Pakgon on 9/26/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

class AuthenStore {
    private var preference: UserDefaults?
    private var TOKEN_KEY = "token_key"
    
    init() {
        preference = UserDefaults.standard
    }
    
    public func storeToken(_ token: String){
        preference?.set(token, forKey: TOKEN_KEY)
        preference?.synchronize()
    }
    
    public func restoreToken() -> String {
        if let token = preference?.string(forKey: TOKEN_KEY){
            return token
        }
        
        return ""
    }
}
