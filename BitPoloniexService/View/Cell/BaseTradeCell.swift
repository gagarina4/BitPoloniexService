//
//  BaseTradeCell.swift
//  BitPoloniexService
//
//  Created by Anton on 19.12.2018.
//  Copyright © 2018 InterviewTask. All rights reserved.
//

import UIKit

class BaseTradeCell: UITableViewCell {

    var tickerViewModel: TickerViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
