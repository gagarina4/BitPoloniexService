//
//  TickerSecondCell.swift
//  BitPoloniexService
//
//  Created by Anton on 20.12.2018.
//  Copyright © 2018 InterviewTask. All rights reserved.
//

import UIKit

class TickerSecondCell: BaseTradeCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tickerName: UILabel!
    @IBOutlet weak var lowestAsk: UILabel!
    @IBOutlet weak var highestBid: UILabel!
    @IBOutlet weak var baseCurrencyVolume: UILabel!
    
    override var tickerViewModel: TickerViewModel! {
        didSet {
            tickerName.text = tickerViewModel.tikerName
            lowestAsk.text = "ASK: \(tickerViewModel.lowestAsk)"
            highestBid.text = "BID: \(tickerViewModel.highestBid)"
            baseCurrencyVolume.text = (String(format: "%.1f", tickerViewModel.baseCurrencyVolume))
            
            setupTickerViewModelObservers()
        }
    }
    
    fileprivate func setupTickerViewModelObservers() {
        tickerViewModel.lowestAskObserver = { [weak self] (newValue) in
            self?.lowestAsk.text = "ASK: " + newValue
        }
        
        tickerViewModel.highestBidObserver = { [weak self] (newValue) in
            self?.highestBid.text = "BID: " + newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 12
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
