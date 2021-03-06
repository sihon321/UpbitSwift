//
//  Accounts.swift
//  upbit-swift
//
//  Created by ocean on 2021/03/11.
//

import Foundation

// MARK: - UpbitCandle
public struct UpbitAccount: Codable {
    public let currency: String
    public let balance: String
    public let locked: String
    public let avgBuyPrice: String
    public let avgBuyPriceModified: Bool
    public let unitCurrency: String
    
    enum CodingKeys: String, CodingKey {
        case currency, balance, locked
        case avgBuyPrice = "avg_buy_price"
        case avgBuyPriceModified = "avg_buy_price_modified"
        case unitCurrency = "unit_currency"
    }
}

extension UpbitAccount {
    public init(_ json: String?, using encoding: String.Encoding = .utf8) throws {
        guard let jsonString = json,
            let data = jsonString.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    public init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitAccount.self, from: data)
    }
}

public typealias UpbitAccounts = [UpbitAccount]

extension UpbitAccounts {
    public init(_ json: String?, using encoding: String.Encoding = .utf8) throws {
        guard let jsonString = json,
            let data = jsonString.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    public init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitAccounts.self, from: data)
    }
}
