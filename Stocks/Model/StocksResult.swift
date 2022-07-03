//
//  StocksResult.swift
//  Stocks
//
//  Created by Mac on 6/25/22.
//  Copyright © 2022 ramy. All rights reserved.
//

import Foundation

struct StocksResults: Codable {
    let item: [StocksResult]
    
    enum CodingKeys: String, CodingKey {
           case item =  "bestMatches"
       }
}

struct StocksResult: Codable {
    let symbol: String
    let name: String?
    let type: String
    let currency: String
    let matchScore: String
    
    enum CodingKeys: String, CodingKey {
        case symbol =  "1. symbol"
        case name = "2. name"
        case type = "3. type"
        case currency = "8. currency"
        case matchScore = "9. matchScore"
    }
}
