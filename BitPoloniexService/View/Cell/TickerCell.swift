//
//  TickerCell.swift
//  BitPoloniexService
//
//  Created by Anton on 19.12.2018.
//  Copyright © 2018 InterviewTask. All rights reserved.
//

import UIKit

class TickerCell: BaseTradeCell {

    @IBOutlet weak var tickerName: UILabel!
    @IBOutlet weak var lastTradePrice: UILabel!
    @IBOutlet weak var baseCurrencyVolume: UILabel!
    @IBOutlet weak var tickerPercent: UILabel!
    @IBOutlet weak var limitValueImage: UIImageView!

    override var tickerViewModel: TickerViewModel! {
        didSet {
                tickerName.text = tickerViewModel.tikerName
                lastTradePrice.text = "\(tickerViewModel.lastTradePrice)"
                baseCurrencyVolume.text = (String(format: "%.1f", tickerViewModel.baseCurrencyVolume))
                let persentage = String(format: "%.1f", tickerViewModel.percentChangeInLastDay)
                tickerViewModel.percentChangeInLastDay >= 0 ? (tickerPercent.textColor = .green) : (tickerPercent.textColor = .red)
                tickerPercent.text = persentage + "%"
                
                limitValueImage.image = UIImage()
                if let value = tickerViewModel.limitValue {
                    value ? (limitValueImage.image = UIImage(named: "ic_arrow_red")) : (limitValueImage.image = UIImage(named: "ic_arrow_green"))
                }
                setupTickerViewModelObservers()
        }
    }
    
    fileprivate func setupTickerViewModelObservers() {
        tickerViewModel.lastTradePriceObserver = { [weak self] (value, isGreater) in
            self?.lastTradePrice.text = value
            isGreater ? self?.blinkGreater() : self?.blinkLower()
        }
        
        tickerViewModel.limitValueObserver = { [weak self] (isGreater) in
            isGreater ? (self?.limitValueImage.image = UIImage(named: "ic_arrow_red")) : (self?.limitValueImage.image = UIImage(named: "ic_arrow_green"))
        }
        
        tickerViewModel.baseCurrencyVolumeObserver = { [weak self] (newValue) in
            self?.baseCurrencyVolume.text = newValue
        }
    }
    
    fileprivate func blinkGreater() {
        self.backgroundColor = .red
        UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
            self.backgroundColor = .white
        }, completion: nil)
    }
    
    fileprivate func blinkLower() {
        self.backgroundColor = .green
        UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
            self.backgroundColor = .white
        }, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        limitValueImage.image = UIImage()
    }
    
}
