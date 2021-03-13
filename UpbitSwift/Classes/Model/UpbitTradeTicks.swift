//
//  UpbitTradeTicks.swift
//  UpbitSwift
//
//  Created by ocean on 2021/03/13.
//

import Foundation

// MARK: - UpbitTradeTick
public struct UpbitTradeTick: Codable {
    let market, tradeDateUTC, tradeTimeUTC: String
    let timestamp: Int
    let tradePrice, tradeVolume: Double
    let prevClosingPrice, changePrice: Double
    let askBid: String
    let sequentialId: Int?

    enum CodingKeys: String, CodingKey {
        case market
        case tradeDateUTC = "trade_date_utc"
        case tradeTimeUTC = "trade_time_utc"
        case timestamp
        case tradePrice = "trade_price"
        case tradeVolume = "trade_volume"
        case prevClosingPrice = "prev_closing_price"
        case changePrice = "change_price"
        case askBid = "ask_bid"
        case sequentialId = "sequential_id"
    }
}

extension UpbitTradeTick {
    init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitTradeTick.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        market = try values.decode(String.self, forKey: .market)
        tradeDateUTC = try values.decode(String.self, forKey: .tradeDateUTC)
        tradeTimeUTC = try values.decode(String.self, forKey: .tradeTimeUTC)
        timestamp = try values.decode(Int.self, forKey: .timestamp)
        tradePrice = try values.decode(Double.self, forKey: .tradePrice)
        tradeVolume = try values.decode(Double.self, forKey: .tradeVolume)
        prevClosingPrice = try values.decode(Double.self, forKey: .prevClosingPrice)
        changePrice = try values.decode(Double.self, forKey: .changePrice)
        askBid = try values.decode(String.self, forKey: .askBid)
        sequentialId = try values.decodeIfPresent(Int.self, forKey: .sequentialId)
    }
}

public typealias UpbitTradeTicks = [UpbitTradeTick]

extension UpbitTradeTicks {
    init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitTradeTicks.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}
