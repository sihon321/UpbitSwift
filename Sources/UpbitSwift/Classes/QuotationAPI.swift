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
    
    init?(value: String) {
        switch num {
        case "분"(let minute): self = .minute(minute)
        case "시"(let hour): self = .hour(hour)
        case "일": self = .days
        case "주": self = .weeks
        case "월": self = .months
        default:    self = nil
        }
    }
}

public enum MinuteCandle: Int {
    case one = 1
    case three = 3
    case five = 5
    case ten = 10
    case fifteen = 15
    case thirty = 30
    
    init?(value: String) {
        switch num {
        case "1": self = .one
        case "3": self = .three
        case "5": self = .five
        case "10": self = .ten
        case "15": self = .fifteen
        case "30": self = .thirty
        default:    self = nil
        }
    }
    
    init?(value: Int) {
        switch num {
        case 1: self = .one
        case 3: self = .three
        case 5: self = .five
        case 10: self = .ten
        case 15: self = .fifteen
        case 30: self = .thirty
        default:    self = nil
        }
    }
}

public enum HourCandle: Int {
    case one = 60
    case four = 240
    
    init?(value: String) {
        switch num {
        case "60": self = .one
        case "240": self = .four
        default:    self = nil
        }
    }
    
    init?(value: Int) {
        switch num {
        case 60: self = .one
        case 240: self = .four
        default:    self = nil
        }
    }
}
