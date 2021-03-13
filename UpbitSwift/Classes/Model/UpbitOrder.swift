//
//  UpbitOrder.swift
//  UpbitSwift
//
//  Created by ocean on 2021/03/13.
//

import Foundation

// MARK: - UpbitOrder
public struct UpbitOrder: Codable {
    let uuid, side, ordType, price: String
    let avgPrice: String?
    let state, market: String
    let createdAt: String
    let volume, remainingVolume, reservedFee, remainingFee: String
    let paidFee, locked, executedVolume: String
    let tradesCount: Int
    let trades: [UpbitTrade]?

    enum CodingKeys: String, CodingKey {
        case uuid, side
        case ordType = "ord_type"
        case price, state, market
        case avgPrice = "avg_price"
        case createdAt = "created_at"
        case volume
        case remainingVolume = "remaining_volume"
        case reservedFee = "reserved_fee"
        case remainingFee = "remaining_fee"
        case paidFee = "paid_fee"
        case locked
        case executedVolume = "executed_volume"
        case tradesCount = "trades_count"
        case trades
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        uuid = try values.decode(String.self, forKey: .uuid)
        side = try values.decode(String.self, forKey: .side)
        ordType = try values.decode(String.self, forKey: .ordType)
        price = try values.decode(String.self, forKey: .price)
        avgPrice = try values.decodeIfPresent(String.self, forKey: .avgPrice)
        state = try values.decode(String.self, forKey: .state)
        market = try values.decode(String.self, forKey: .market)
        createdAt = try values.decode(String.self, forKey: .createdAt)
        volume = try values.decode(String.self, forKey: .volume)
        remainingVolume = try values.decode(String.self, forKey: .remainingVolume)
        reservedFee = try values.decode(String.self, forKey: .reservedFee)
        remainingFee = try values.decode(String.self, forKey: .remainingFee)
        paidFee = try values.decode(String.self, forKey: .paidFee)
        locked = try values.decode(String.self, forKey: .locked)
        executedVolume = try values.decode(String.self, forKey: .executedVolume)
        tradesCount = try values.decode(Int.self, forKey: .tradesCount)
        trades = try values.decodeIfPresent([UpbitTrade].self, forKey: .trades)
    }
}

// MARK: UpbitOrder convenience initializers and mutators

extension UpbitOrder {
    init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitOrder.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

}

// MARK: - Trade
struct UpbitTrade: Codable {
    let market, uuid, price, volume: String
    let funds, side: String
}

// MARK: Trade convenience initializers and mutators

extension UpbitTrade {
    init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitTrade.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}

public typealias UpbitOrders = [UpbitOrder]

extension UpbitOrders {
    init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitOrders.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}
