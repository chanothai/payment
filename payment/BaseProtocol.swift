//
//  BaseProtocol.swift
//  payment
//
//  Created by Pakgon on 7/12/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

public protocol BaseViewModelDelegate: class {
    //Load data
    func onDataDidLoad()
    func onDataDidLoadErrorWithMessage(errorMessage:String)
    
    //Loading
    func showLoading()
    func hideLoading()
}
