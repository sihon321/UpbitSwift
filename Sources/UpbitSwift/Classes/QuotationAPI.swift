//
//  QuotationAPI.swift
//  upbit-swift
//
//  Created by ocean on 2021/03/10.
//

import Foundation

public enum QuotationAPI {
    
    case marketAll, candles(CandleType), tradesTicks, ticker, orderbook
}

extension QuotationAPI {
    var path: String {
        switch self {
        case .marketAll: return "/market/all"
        case .candles(let type):
            switch type {
            case .minute(let unit):
                return "/candles/minutes/\(unit.rawValue)"
            case .hour(let unit):
                return "/candles/minutes/\(unit.rawValue)"
            case .days:
                return "/candles/days"
            case .weeks:
                return "/candles/weeks"
            case .months:
                return "/candles/months"
            }
        case .tradesTicks: return "/trades/ticks"
        case .ticker: return "/ticker"
        case .orderbook: return "/orderbook"
        }
    }
}

public enum CandleType {
    case minute(MinuteCandle)
    case hour(HourCandle)
    case days
    case weeks
    case months
}

public enum MinuteCandle: Int {
    case one = 1
    case three = 3
    case five = 5
    case ten = 10
    case fifteen = 15
    case thirty = 30
}

public enum HourCandle: Int {
    case one = 60
    case four = 240
}
