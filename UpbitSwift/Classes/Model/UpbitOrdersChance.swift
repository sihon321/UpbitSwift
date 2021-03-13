//
//  OrdersChance.swift
//  UpbitSwift
//
//  Created by ocean on 2021/03/13.
//

import Foundation

// MARK: - OrdersChance
public struct UpbitOrdersChance: Codable {
    let bidFee, askFee: String
    let makerBidFee, makerAskFee: String
    let market: UpbitOrderMarket
    let bidAccount, askAccount: UpbitOrderAccount

    enum CodingKeys: String, CodingKey {
        case bidFee = "bid_fee"
        case askFee = "ask_fee"
        case makerBidFee = "maker_bid_fee"
        case makerAskFee = "maker_ask_fee"
        case market
        case bidAccount = "bid_account"
        case askAccount = "ask_account"
    }
}

extension UpbitOrdersChance {
    init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitOrdersChance.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}

// MARK: - Account
public struct UpbitOrderAccount: Codable {
    let currency, balance, locked, avgBuyPrice: String
    let avgBuyPriceModified: Bool
    let unitCurrency: String

    enum CodingKeys: String, CodingKey {
        case currency, balance, locked
        case avgBuyPrice = "avg_buy_price"
        case avgBuyPriceModified = "avg_buy_price_modified"
        case unitCurrency = "unit_currency"
    }
}

extension UpbitOrderAccount {
    init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitOrderAccount.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}

// MARK: - UpbitOrderMarket
public struct UpbitOrderMarket: Codable {
    let id, name: String
    let orderTypes, orderSides: [String]
    let bid, ask: UpbitOrderAsk
    let maxTotal, state: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case orderTypes = "order_types"
        case orderSides = "order_sides"
        case bid, ask
        case maxTotal = "max_total"
        case state
    }
}

extension UpbitOrderMarket {
    init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitOrderMarket.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}

// MARK: - Ask
public struct UpbitOrderAsk: Codable {
    let currency: String
    let priceUnit: String?
    let minTotal: String

    enum CodingKeys: String, CodingKey {
        case currency
        case priceUnit = "price_unit"
        case minTotal = "min_total"
    }
}

// MARK: Ask convenience initializers and mutators

extension UpbitOrderAsk {
    init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitOrderAsk.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        currency = try values.decode(String.self, forKey: .currency)
        priceUnit = try values.decodeIfPresent(String.self, forKey: .priceUnit)
        minTotal = try values.decode(String.self, forKey: .minTotal)
    }
}
