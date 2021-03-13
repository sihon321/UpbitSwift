//
//  UpbitTickers.swift
//  UpbitSwift
//
//  Created by ocean on 2021/03/13.
//

import Foundation

// MARK: - UpbitTicker
public struct UpbitTicker: Codable {
    let market, tradeDate, tradeTime, tradeDateKst: String
    let tradeTimeKst: String
    let tradeTimestamp, openingPrice, highPrice, lowPrice: Int
    let tradePrice, prevClosingPrice: Int
    let change: String
    let changePrice: Int
    let changeRate: Double
    let signedChangePrice: Int
    let signedChangeRate, tradeVolume, accTradePrice, accTradePrice24H: Double
    let accTradeVolume, accTradeVolume24H: Double
    let highest52_WeekPrice: Int
    let highest52_WeekDate: String
    let lowest52_WeekPrice: Int
    let lowest52_WeekDate: String
    let timestamp: Int

    enum CodingKeys: String, CodingKey {
        case market
        case tradeDate = "trade_date"
        case tradeTime = "trade_time"
        case tradeDateKst = "trade_date_kst"
        case tradeTimeKst = "trade_time_kst"
        case tradeTimestamp = "trade_timestamp"
        case openingPrice = "opening_price"
        case highPrice = "high_price"
        case lowPrice = "low_price"
        case tradePrice = "trade_price"
        case prevClosingPrice = "prev_closing_price"
        case change
        case changePrice = "change_price"
        case changeRate = "change_rate"
        case signedChangePrice = "signed_change_price"
        case signedChangeRate = "signed_change_rate"
        case tradeVolume = "trade_volume"
        case accTradePrice = "acc_trade_price"
        case accTradePrice24H = "acc_trade_price_24h"
        case accTradeVolume = "acc_trade_volume"
        case accTradeVolume24H = "acc_trade_volume_24h"
        case highest52_WeekPrice = "highest_52_week_price"
        case highest52_WeekDate = "highest_52_week_date"
        case lowest52_WeekPrice = "lowest_52_week_price"
        case lowest52_WeekDate = "lowest_52_week_date"
        case timestamp
    }
}

extension UpbitTicker {
    init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitTicker.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}

public typealias UpbitTickers = [UpbitTicker]

extension UpbitTickers {
    init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitTickers.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}
