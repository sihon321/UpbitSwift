//
//  UpbitCandle.swift
//  UpbitSwift
//
//  Created by ocean on 2021/03/13.
//

import Foundation

// MARK: - UpbitCandle
public struct UpbitCandle: Codable {
    public let market, candleDateTimeUTC, candleDateTimeKst: String
    public let openingPrice, highPrice, lowPrice, tradePrice: Int
    public let timestamp: Int
    public let candleAccTradePrice, candleAccTradeVolume: Double
    public let unit, changePrice: Int?
    public let changeRate: Double?

    enum CodingKeys: String, CodingKey {
        case market
        case candleDateTimeUTC = "candle_date_time_utc"
        case candleDateTimeKst = "candle_date_time_kst"
        case openingPrice = "opening_price"
        case highPrice = "high_price"
        case lowPrice = "low_price"
        case tradePrice = "trade_price"
        case timestamp
        case candleAccTradePrice = "candle_acc_trade_price"
        case candleAccTradeVolume = "candle_acc_trade_volume"
        case unit
        case changePrice = "change_price"
        case changeRate = "change_rate"
    }
}

extension UpbitCandle {
    public init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitCandle.self, from: data)
    }

    public init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        market = try values.decode(String.self, forKey: .market)
        candleDateTimeUTC = try values.decode(String.self, forKey: .candleDateTimeUTC)
        candleDateTimeKst = try values.decode(String.self, forKey: .candleDateTimeKst)
        openingPrice = try values.decode(Int.self, forKey: .openingPrice)
        highPrice = try values.decode(Int.self, forKey: .highPrice)
        lowPrice = try values.decode(Int.self, forKey: .lowPrice)
        tradePrice = try values.decode(Int.self, forKey: .tradePrice)
        timestamp = try values.decode(Int.self, forKey: .timestamp)
        candleAccTradePrice = try values.decode(Double.self, forKey: .candleAccTradePrice)
        candleAccTradeVolume = try values.decode(Double.self, forKey: .candleAccTradeVolume)
        unit = try values.decodeIfPresent(Int.self, forKey: .unit)
        changePrice = try values.decodeIfPresent(Int.self, forKey: .changePrice)
        changeRate = try values.decodeIfPresent(Double.self, forKey: .changeRate)
    }
}

public typealias UpbitCandles = [UpbitCandle]

extension UpbitCandles {
    public init(_ json: String?, using encoding: String.Encoding = .utf8) throws {
        guard let jsonString = json,
            let data = jsonString.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    public init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitCandles.self, from: data)
    }
}
