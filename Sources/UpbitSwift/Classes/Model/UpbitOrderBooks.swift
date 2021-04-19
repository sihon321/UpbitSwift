//
//  UpbitOrderBooks.swift
//  UpbitSwift
//
//  Created by ocean on 2021/03/13.
//

// MARK: - UpbitOrderBook
public struct UpbitOrderBook: Codable {
    public let market: String
    public let timestamp: Int
    public let totalAskSize, totalBidSize: Double
    public let orderbookUnits: [OrderbookUnit]

    enum CodingKeys: String, CodingKey {
        case market, timestamp
        case totalAskSize = "total_ask_size"
        case totalBidSize = "total_bid_size"
        case orderbookUnits = "orderbook_units"
    }
}

extension UpbitOrderBook {
    public init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitOrderBook.self, from: data)
    }

    public init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}

// MARK: - OrderbookUnit
public struct OrderbookUnit: Codable {
    public let askPrice, bidPrice: Int
    public let askSize, bidSize: Double

    enum CodingKeys: String, CodingKey {
        case askPrice = "ask_price"
        case bidPrice = "bid_price"
        case askSize = "ask_size"
        case bidSize = "bid_size"
    }
}

extension OrderbookUnit {
    public init(data: Data) throws {
        self = try JSONDecoder().decode(OrderbookUnit.self, from: data)
    }

    public init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}

public typealias UpbitOrderBooks = [UpbitOrderBook]

extension UpbitOrderBooks {
    public init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitOrderBooks.self, from: data)
    }

    public init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}
