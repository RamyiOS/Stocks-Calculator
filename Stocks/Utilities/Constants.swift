//
//  Constants.swift
//  Stocks
//
//  Created by Mac on 7/2/22.
//  Copyright © 2022 ramy. All rights reserved.
//

import Foundation

struct Title {
    static let search = "Search"
    static let noDates = "No Dates"
    static let ok = "Ok"
    static let selectDate = "Select date"
    static let done = "Done"
}

struct Identifier {
    static let claculatoerSegue = "showCalculator"
    static let stockCellId = "StocksCell"
    static let showInvestDate = "showInvestDate"
    static let dateCellId = "cellId"
}

struct Placeholder {
    static let searchBarPlaceholder = "Enter Company name"
}

struct Message {
    static let alertMessage = "Sorry you can not calculate investments for this company now because of problem of loading previous investment dates"
    static let oneMonthAgo = "1 month ago"
    static let justInvested = "Just invested"
}

struct DefaultValue {
    static let zeros = "0.00"
    static let dash = "-"
    static let emptyString = ""
    static let plus = "+"
}

struct APIKeys {
    static let firstKey = "DGADWMENMD0D65RA"
    static let secondKey = "O39H0Y0WTEUXN4MX"
    static let thirdKey = "5RHXX5JNU0KWWEZU"
}

struct Format {
    static let monthYearFormat = "MMMM yyyy"
}
