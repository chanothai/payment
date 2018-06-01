//
//  moneyFormatter.swift
//  payment
//
//  Created by Pakgon on 4/21/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

class moneyFormatter {
    func thaiFormatter(_ value:Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        
        currencyFormatter.currencySymbol = ""
        let result = currencyFormatter.string(from: value as NSNumber)
        return result!
    }
}
