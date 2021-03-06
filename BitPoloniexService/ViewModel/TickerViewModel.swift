//
//  TickerViewModel.swift
//  BitPoloniexService
//
//  Created by Anton on 20.12.2018.
//  Copyright © 2018 InterviewTask. All rights reserved.
//

import UIKit

protocol ProducesTickerViewModel {
    func convertToTickerViewModel() -> TickerViewModel
}

class TickerViewModel {
    
    var id: String
    var tikerName: String
    var percentChangeInLastDay: Float
    var lowestAsk: Float {
        didSet {
            if lowestAsk != oldValue {
                lowestAskObserver?("\(lowestAsk)")
            }
        }
    }
    var highestBid: Float {
        didSet {
            if highestBid != oldValue {
                highestBidObserver?("\(highestBid)")
            }
        }
    }
    var baseCurrencyVolume: Double {
        didSet {
            if baseCurrencyVolume != oldValue {
                baseCurrencyVolumeObserver?(String(format: "%.1f", baseCurrencyVolume))
            }
        }
    }
    var lastTradePrice: Double {
        didSet {
            if lastTradePrice != oldValue {
                lastTradePriceObserver?("\(lastTradePrice)", lastTradePrice > oldValue)
            }
        }
    }
    var limitValue: Bool? {
        didSet {
            limitValueObserver?(limitValue!)
        }
    }
    
    // Observers
    var limitValueObserver: ((Bool) -> ())?
    var lastTradePriceObserver: ((String, Bool) -> ())?
    var lowestAskObserver: ((String) -> ())?
    var highestBidObserver: ((String) -> ())?
    var baseCurrencyVolumeObserver: ((String) -> ())?
    
    init(id: String, lastTradePrice: Double, lowestAsk: Float, highestBid: Float,  percent: Float, baseCurrencyVolume: Double) {
        self.id = id
        self.tikerName = currencyChannels[id] ?? ""
        self.lastTradePrice = lastTradePrice
        self.percentChangeInLastDay = percent*100
        self.lowestAsk = lowestAsk
        self.highestBid = highestBid
        self.baseCurrencyVolume = baseCurrencyVolume
    }
    
    func updateLimitValue(newLimitValue: Double) {
        if newLimitValue != self.lastTradePrice {
            limitValue = (newLimitValue < self.lastTradePrice)
        }
    }
    
    fileprivate var currencyChannels: [String:String] = [
        "7":"BTC_BCN",
        "14":"BTC_BTS",
        "15":"BTC_BURST",
        "20":"BTC_CLAM",
        "25":"BTC_DGB",
        "27":"BTC_DOGE",
        "24":"BTC_DASH",
        "38":"BTC_GAME",
        "43":"BTC_HUC",
        "50":"BTC_LTC",
        "51":"BTC_MAID",
        "58":"BTC_OMNI",
        "61":"BTC_NAV",
        "64":"BTC_NMC",
        "69":"BTC_NXT",
        "75":"BTC_PPC",
        "89":"BTC_STR",
        "92":"BTC_SYS",
        "97":"BTC_VIA",
        "100":"BTC_VTC",
        "108":"BTC_XCP",
        "114":"BTC_XMR",
        "116":"BTC_XPM",
        "117":"BTC_XRP",
        "112":"BTC_XEM",
        "148":"BTC_ETH",
        "150":"BTC_SC",
        "155":"BTC_FCT",
        "162":"BTC_DCR",
        "163":"BTC_LSK",
        "167":"BTC_LBC",
        "168":"BTC_STEEM",
        "170":"BTC_SBD",
        "171":"BTC_ETC",
        "174":"BTC_REP",
        "177":"BTC_ARDR",
        "178":"BTC_ZEC",
        "182":"BTC_STRAT",
        "184":"BTC_PASC",
        "185":"BTC_GNT",
        "189":"BTC_BCH",
        "192":"BTC_ZRX",
        "194":"BTC_CVC",
        "196":"BTC_OMG",
        "198":"BTC_GAS",
        "200":"BTC_STORJ",
        "201":"BTC_EOS",
        "204":"BTC_SNT",
        "207":"BTC_KNC",
        "210":"BTC_BAT",
        "213":"BTC_LOOM",
        "221":"BTC_QTUM",
        "232":"BTC_BNT",
        "229":"BTC_MANA",
        "246":"BTC_FOAM",
        "236":"BTC_BCHABC",
        "238":"BTC_BCHSV",
        "248":"BTC_NMR",
        "249":"BTC_POLY",
        "250":"BTC_LPT",
        "121":"USDT_BTC",
        "216":"USDT_DOGE",
        "122":"USDT_DASH",
        "123":"USDT_LTC",
        "124":"USDT_NXT",
        "125":"USDT_STR",
        "126":"USDT_XMR",
        "127":"USDT_XRP",
        "149":"USDT_ETH",
        "219":"USDT_SC",
        "218":"USDT_LSK",
        "173":"USDT_ETC",
        "175":"USDT_REP",
        "180":"USDT_ZEC",
        "217":"USDT_GNT",
        "191":"USDT_BCH",
        "220":"USDT_ZRX",
        "203":"USDT_EOS",
        "206":"USDT_SNT",
        "209":"USDT_KNC",
        "212":"USDT_BAT",
        "215":"USDT_LOOM",
        "223":"USDT_QTUM",
        "234":"USDT_BNT",
        "231":"USDT_MANAv",
        "129":"XMR_BCNv",
        "132":"XMR_DASH",
        "137":"XMR_LTC",
        "138":"XMR_MAID",
        "140":"XMR_NXT",
        "181":"XMR_ZEC",
        "166":"ETH_LSK",
        "169":"ETH_STEEM",
        "172":"ETH_ETC",
        "176":"ETH_REP",
        "179":"ETH_ZEC",
        "186":"ETH_GNTv",
        "190":"ETH_BCH",
        "193":"ETH_ZRX",
        "195":"ETH_CVC",
        "197":"ETH_OMG",
        "199":"ETH_GAS",
        "202":"ETH_EOS",
        "205":"ETH_SNT",
        "208":"ETH_KNC",
        "211":"ETH_BAT",
        "214":"ETH_LOOM",
        "222":"ETH_QTUM",
        "233":"ETH_BNT",
        "230":"ETH_MANA",
        "224":"USDC_BTC",
        "243":"USDC_DOGE",
        "244":"USDC_LTC",
        "242":"USDC_STR",
        "226":"USDC_USDT",
        "241":"USDC_XMR",
        "240":"USDC_XRP",
        "225":"USDC_ETH",
        "245":"USDC_ZEC",
        "235":"USDC_BCH",
        "247":"USDC_FOAMv",
        "237":"USDC_BCHABvC",
        "239":"USDC_BCHSV"
    ]
    
}
