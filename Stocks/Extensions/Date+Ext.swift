//
//  Date+Ext.swift
//  Stocks
//
//  Created by Mac on 6/27/22.
//  Copyright © 2022 ramy. All rights reserved.
//

import Foundation

extension Date {
    
    var MMYYFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Format.monthYearFormat
        return dateFormatter.string(from: self)
    }
}
