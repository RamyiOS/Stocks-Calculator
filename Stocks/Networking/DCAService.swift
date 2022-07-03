//
//  DCAService.swift
//  Stocks
//
//  Created by Mac on 6/27/22.
//  Copyright © 2022 ramy. All rights reserved.
//

import Foundation

struct DCAService {

    func calculate(asset: Asset, initialInvesedAmount: Double, monthlyInvests: Double,initialDateOfInvests: Int) -> DCAResult {
        
        let investmentAmount = getInvestmentAmount(initialInvesedAmount: initialInvesedAmount, monthlyInvests: monthlyInvests, initialDateOfInvests: initialDateOfInvests)
        
        let latestSharePrice = getLatestSharePrice(asset: asset)
        
        let numberOfShares = getNumberOfShares(asset: asset, initialInvesedAmount: initialInvesedAmount, monthlyInvests: monthlyInvests, initialDateOfInvests: initialDateOfInvests)
        
        let currentValue = getCurrentValue(numberOfShares: numberOfShares, latestSharePrice: latestSharePrice)
        
        let isProfitable = currentValue > investmentAmount
        
        let gain = currentValue - investmentAmount
        
        let yield = gain / investmentAmount
        
        let annualReturn = getAnnualReturn(currentValue: currentValue, investmentAmount: investmentAmount, initialDateOfInvests: initialDateOfInvests)
        
        
        return .init(currentValue: currentValue, investmentAmount: investmentAmount, gain: gain, yield: yield, annualReturn: annualReturn, isProfitable: isProfitable)
    }
    
    func getInvestmentAmount(initialInvesedAmount: Double, monthlyInvests: Double, initialDateOfInvests: Int) -> Double {
        var totalAmount = Double()
        totalAmount += initialInvesedAmount
        
        let dollarCostAveragingAmount = initialDateOfInvests.doubleValue * monthlyInvests
        totalAmount += dollarCostAveragingAmount
        return totalAmount
    }
    
    private func getAnnualReturn(currentValue: Double, investmentAmount: Double, initialDateOfInvests: Int) -> Double {
        let rate = currentValue / investmentAmount
        let years = (initialDateOfInvests.doubleValue + 1) / 12
        let result = pow(rate, (1 / years)) - 1
        return result
    }
    
    private func getCurrentValue(numberOfShares: Double, latestSharePrice: Double) -> Double {
        return numberOfShares * latestSharePrice
    }
    
    private func getLatestSharePrice(asset: Asset) -> Double {
        return asset.timeSeriesMonthlyAdjusted.getMonthInfos().first?.adjustedClose ?? 0
    }
    
    private func getNumberOfShares(asset: Asset, initialInvesedAmount: Double, monthlyInvests: Double, initialDateOfInvests: Int) -> Double {
        var totalShares = Double()
        let initialInvestmentOpenPrice = asset.timeSeriesMonthlyAdjusted.getMonthInfos()[initialDateOfInvests].adjustedOpen
        let initialInvestmentShares = initialInvesedAmount / initialInvestmentOpenPrice
        totalShares += initialInvestmentShares
        
        asset.timeSeriesMonthlyAdjusted.getMonthInfos().prefix(initialDateOfInvests).forEach { (monthInfo) in
            let dcaInvestmentShares = monthlyInvests / monthInfo.adjustedOpen
            totalShares += dcaInvestmentShares
        }
        return totalShares
    }
}

