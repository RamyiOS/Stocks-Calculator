//
//  CalculatorPresenter.swift
//  Stocks
//
//  Created by Mac on 6/27/22.
//  Copyright © 2022 ramy. All rights reserved.
//

import UIKit

struct CalculatorPresenter {
    
    func getPresentation(result: DCAResult) -> CalculatorPresentation {
        let isProfitable = result.isProfitable == true
        let gainSymbol = isProfitable ? DefaultValue.plus : DefaultValue.emptyString
        return .init(currentValueLabelTextColor: isProfitable ? .systemGreen : .systemRed,
                     currentValue: result.currentValue.twoDecimalPlaceString,
                     investmentAmount: result.investmentAmount.twoDecimalPlaceString,
                     gain: result.gain.twoDecimalPlaceString.prefix(withText: gainSymbol),
                     yield: result.yield.percentageFormat.prefix(withText: gainSymbol).addBrackets(),
                     yieldLabelTextColor: isProfitable ? .systemGreen : .systemRed,
                     annualReturn: result.annualReturn.percentageFormat,
                     annualReturnLabelTextColor: isProfitable ? .systemGreen : .systemRed)
    }
}

struct CalculatorPresentation {
    let currentValueLabelTextColor: UIColor
    let currentValue: String
    let investmentAmount: String
    let gain: String
    let yield: String
    let yieldLabelTextColor: UIColor
    let annualReturn: String
    let annualReturnLabelTextColor: UIColor
}
