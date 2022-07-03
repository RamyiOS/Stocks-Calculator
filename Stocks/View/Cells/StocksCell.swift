//
//  StocksCell.swift
//  Stocks
//
//  Created by Mac on 6/25/22.
//  Copyright © 2022 ramy. All rights reserved.
//

import UIKit

class StocksCell: UITableViewCell {
    
    let reusableID = Identifier.stockCellId
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var matchScore: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    func configer(stocksResult: StocksResult) {
        nameLabel.text = stocksResult.name
        symbolLabel.text = stocksResult.symbol
        matchScore.text = stocksResult.matchScore
        typeLabel.text = stocksResult.type.appending(" ").appending(stocksResult.currency)
    }
    
    func layoutCell() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.darkGray.cgColor
        contentView.layer.borderWidth = 0.5
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowColor = UIColor.darkGray.cgColor
        contentView.layer.shadowRadius = 20
        contentView.layer.shadowOpacity = 0.60
        contentView.layer.shadowRadius = 4
    }
}
