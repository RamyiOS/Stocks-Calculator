//
//  NetworkManager.swift
//  Stocks
//
//  Created by Mac on 6/25/22.
//  Copyright © 2022 ramy. All rights reserved.
//

import Foundation
import Combine

class NetworkManager {
    
    enum APIError: Error {
        case encoding
        case badRequest
    }
    
    var apiKey: String {
        return keys.randomElement() ?? DefaultValue.emptyString
    }
    
    let keys = [APIKeys.firstKey, APIKeys.secondKey , APIKeys.thirdKey ]
    
    
    func fetchPublisher(keywords: String) -> AnyPublisher<StocksResults, Error> {
        let result = parseQuery(text: keywords)
        var symbol = String()
        
        switch result {
        case .success(let query):
            symbol = query
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(apiKey)"
        let urlResult = parseURL(urlString: urlString)
        
        switch urlResult {
        case .success(let url):
            return URLSession.shared.dataTaskPublisher(for: url).map({ $0.data }).decode(type: StocksResults
                .self, decoder: JSONDecoder()).receive(on: RunLoop.main).eraseToAnyPublisher()
            
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func fetchTimeSeriesMonthlyAdjustedPublisher(keywords: String) -> AnyPublisher<TimeSeriesMonthlyAdjusted, Error> {
        let result = parseQuery(text: keywords)
        var symbol = String()
        
        switch result {
        case .success(let query):
            symbol = query
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=\(symbol)&apikey=\(apiKey)"
        let urlResult = parseURL(urlString: urlString)
        
        switch urlResult {
        case .success(let url):
            return URLSession.shared.dataTaskPublisher(for: url).map({ $0.data }).decode(type: TimeSeriesMonthlyAdjusted.self, decoder: JSONDecoder()).receive(on: RunLoop.main).eraseToAnyPublisher()
            
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    private func parseQuery(text: String) -> Result<String, Error> {
        if let query = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            return .success(query)
        } else {
            return .failure(APIError.encoding)
        }
    }
    
    private func parseURL(urlString: String) -> Result<URL, Error> {
        if let url = URL(string: urlString) {
            return .success(url)
        } else {
            return .failure(APIError.badRequest)
        }
    }
}

