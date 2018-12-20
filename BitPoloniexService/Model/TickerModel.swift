//
//  TickerModel.swift
//  BitPoloniexService
//
//  Created by Anton on 19.12.2018.
//  Copyright © 2018 InterviewTask. All rights reserved.
//

import UIKit

struct TickerModel: ProducesTickerViewModel {

    var id: String
    var lastTradePrice: Double
    var lowestAsk: Float
    var highestBid: Float
    var percentChangeInLastDay: Float
    var baseCurrencyVolume: Double
    
    init(with data: [String]) {
        //TODO 
        self.id = data[0]
        self.lastTradePrice = Double(data[1]) ?? 0
        self.lowestAsk = Float(data[2]) ?? 0
        self.highestBid = Float(data[3]) ?? 0
        self.percentChangeInLastDay = Float(data[4]) ?? 0
        self.baseCurrencyVolume = Double(data[5]) ?? 0
    }
    
    func convertToTickerViewModel() -> TickerViewModel {
        return TickerViewModel(id: id, lastTradePrice: lastTradePrice, lowestAsk: lowestAsk, highestBid: highestBid,  percent: percentChangeInLastDay, baseCurrencyVolume: baseCurrencyVolume)
    }

}
