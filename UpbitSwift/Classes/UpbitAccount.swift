//
//  Accounts.swift
//  upbit-swift
//
//  Created by ocean on 2021/03/11.
//

import Foundation

// MARK: - UpbitCandle
public struct UpbitAccount: Codable {
    let currency: String
    let balance: String
    let locked: String
    let avgBuyPrice: String
    let avgBuyPriceModified: Bool
    let unitCurrency: String
    
    enum CodingKeys: String, CodingKey {
        case currency, balance, locked
        case avgBuyPrice = "avg_buy_price"
        case avgBuyPriceModified = "avg_buy_price_modified"
        case unitCurrency = "unit_currency"
    }
}

extension UpbitAccount {
    init(_ json: String?, using encoding: String.Encoding = .utf8) throws {
        guard let jsonString = json,
            let data = jsonString.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitAccount.self, from: data)
    }
}

public typealias UpbitAccounts = [UpbitAccount]

extension UpbitAccounts {
    init(_ json: String?, using encoding: String.Encoding = .utf8) throws {
        guard let jsonString = json,
            let data = jsonString.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitAccounts.self, from: data)
    }
}
