//
//  UpbitMarket.swift
//  UpbitSwift
//
//  Created by ocean on 2021/03/13.
//

import Foundation

// MARK: - UpbitMarket
public struct UpbitMarket: Codable {
    public let market: String
    public let koreanName: String
    public let englishName: String
    public let marketWarning: String?
    
    enum CodingKeys: String, CodingKey {
        case market
        case koreanName = "korean_name"
        case englishName = "english_name"
        case marketWarning = "market_warning"
    }
}

extension UpbitMarket {
    public init(_ json: String?, using encoding: String.Encoding = .utf8) throws {
        guard let jsonString = json,
            let data = jsonString.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    public init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitMarket.self, from: data)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        market = try values.decode(String.self, forKey: .market)
        koreanName = try values.decode(String.self, forKey: .koreanName)
        englishName = try values.decode(String.self, forKey: .englishName)
        marketWarning = try values.decodeIfPresent(String.self, forKey: .marketWarning)
    }
}

public typealias UpbitMarketList = [UpbitMarket]

extension UpbitMarketList {
    init(_ json: String?, using encoding: String.Encoding = .utf8) throws {
        guard let jsonString = json,
            let data = jsonString.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(UpbitMarketList.self, from: data)
    }
}
