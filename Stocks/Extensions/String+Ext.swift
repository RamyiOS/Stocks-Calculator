//
//  String+Ext.swift
//  Stocks
//
//  Created by Mac on 6/27/22.
//  Copyright © 2022 ramy. All rights reserved.
//

import Foundation

extension String {
    
    func addBrackets() -> String {
        return "(\(self))"
    }
    
    func prefix(withText text: String) -> String {
        return text + self
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
}
