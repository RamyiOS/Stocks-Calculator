//
//  DateSelectionCell.swift
//  Stocks
//
//  Created by Mac on 6/28/22.
//  Copyright © 2022 ramy. All rights reserved.
//

import UIKit

class DateSelectionCell: UITableViewCell {
    
    let reusableID = Identifier.dateCellId
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthsAgoLabel: UILabel!
    
    func configure(with monthInfo: MonthInfo, index: Int, isSelected: Bool) {
        monthLabel.text = monthInfo.date.MMYYFormat
        accessoryType = isSelected ? .checkmark : .none
        if index == 1 {
            monthsAgoLabel.text = Message.oneMonthAgo
        } else if index > 1 {
            monthsAgoLabel.text = "\(index) months ago"
        } else {
            monthsAgoLabel.text = Message.justInvested
        }
    }
}
