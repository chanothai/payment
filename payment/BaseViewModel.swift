//
//  BaseViewModel.swift
//  payment
//
//  Created by Pakgon on 7/12/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

class BaseViewModel: NSObject {
    public weak var delegate: BaseViewModelDelegate?
    
    required public init(delegate: BaseViewModelDelegate) {
        self.delegate = delegate
    }
}
