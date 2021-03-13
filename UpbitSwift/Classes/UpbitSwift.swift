import Foundation
import Alamofire
import SwiftJWT

open class UpbitSwift {
    let accessKey: String
    let secretKey: String
    
    public init(accessKey: String = "", secretKey: String = "") {
        self.accessKey = accessKey
        self.secretKey = secretKey
    }
    
    func get(_ api: UpbitAPI,
             query parameter: [String: String]? = nil,
             completion: @escaping (Data?, AFError?) -> ()) {
        var components = URLComponents()
        components.queryItems = parameter?.map { URLQueryItem(name: $0, value: $1)}
        let queryHashAlg = components.query?.digest(using: .sha512) ?? ""
        
        var jwt: JWT<Payload>?
        if accessKey != "" {
            jwt = JWT(claims: Payload(access_key: accessKey,
                                      nonce: UUID().uuidString,
                                      query_hash: queryHashAlg,
                                      query_hash_alg: "SHA512"))
        }
        var headers = HTTPHeaders()
        
        if secretKey != "", let secret = secretKey.data(using: .utf8),
           var jwt = jwt, let signedJWT = try? jwt.sign(using: .hs256(key: secret)) {
            let authenticationToken = "Bearer " + signedJWT
            headers.add(name: "Authorization", value: authenticationToken)
        }
        
        AF.request(api.baseURL + api.path, parameters: parameter, headers: headers)
            .responseData { response in
                completion(response.data, response.error)
            }
    }
    
    func get(_ api: UpbitAPI,
             query parameter: [String: String],
             arrayQuery arrayParameter: [String: [String]],
             completion: @escaping (Data?, AFError?) -> ()) {
        guard accessKey != "", secretKey != "" else {
            return
        }
        let arrayQueryString = arrayParameter
            .compactMap({ dictionary in
                return dictionary.value
                    .compactMap({ dictionary.key + "=" + $0 })
                    .joined(separator: "&")
            }).joined(separator: "&")
        let queryString = parameter
            .compactMap({ $0.key + "=" + $0.value })
            .joined(separator: "&")
        
        let queryHashString = queryString + "&" + arrayQueryString
        let requestString = queryHashString.digest(using: .sha512)
        var jwt = JWT(claims: Payload(access_key: accessKey,
                                      nonce: UUID().uuidString,
                                      query_hash: requestString,
                                      query_hash_alg: "SHA512"))
        
        let signedJWT = try? jwt.sign(using: .hs256(key: secretKey.data(using: .utf8)!))
        let authenticationToken = "Bearer " + signedJWT!
        
        AF.request(api.baseURL + api.path + "?" + queryHashString,
                   headers: ["Authorization": authenticationToken])
            .responseData { response in
                completion(response.data, response.error)
            }
    }
    
    func post(_ api: UpbitAPI,
              body parameter: [String: String],
              completion: @escaping (Data?, AFError?) -> ()) {
        guard accessKey != "", secretKey != "" else {
            return
        }
        var components = URLComponents()
        components.queryItems = parameter.map { URLQueryItem(name: $0, value: $1)}
        let queryHashAlg = components.query?.digest(using: .sha512) ?? ""
        
        var jwt: JWT<Payload>?
        jwt = JWT(claims: Payload(access_key: accessKey,
                                  nonce: UUID().uuidString,
                                  query_hash: queryHashAlg,
                                  query_hash_alg: "SHA512"))
        
        var request = URLRequest(url: URL(string: api.baseURL + api.path)!)
        request.httpMethod = "POST"
        
        if var jwt = jwt,
           let secret = secretKey.data(using: .utf8),
           let signedJWT = try? jwt.sign(using: .hs256(key: secret)) {
            let authenticationToken = "Bearer " + signedJWT
            request.addValue(authenticationToken, forHTTPHeaderField: "Authorization")
        }
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: parameter,
                                                          options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request)
            .responseData { response in
                completion(response.data, response.error)
            }
    }
    
    func delete(_ api: UpbitAPI,
                query parameter: [String: String]? = nil,
                completion: @escaping (Data?, AFError?) -> ()) {
        guard accessKey != "", secretKey != "" else {
            return
        }
        var components = URLComponents()
        components.queryItems = parameter?.map { URLQueryItem(name: $0, value: $1)}
        let queryHashAlg = components.query?.digest(using: .sha512) ?? ""
        
        var jwt = JWT(claims: Payload(access_key: accessKey,
                                      nonce: UUID().uuidString,
                                      query_hash: queryHashAlg,
                                      query_hash_alg: "SHA512"))
        var headers = HTTPHeaders()
        
        if let secret = secretKey.data(using: .utf8),
           let signedJWT = try? jwt.sign(using: .hs256(key: secret)) {
            let authenticationToken = "Bearer " + signedJWT
            headers.add(name: "Authorization", value: authenticationToken)
        }
        
        AF.request(api.baseURL + api.path, method: .delete, headers: headers)
            .responseData { response in
                completion(response.data, response.error)
            }
    }
}

// MARK: - QuotationAPI
extension UpbitSwift {
    open func searchMarketAll(isDetails: Bool,
                              completion: @escaping (UpbitMarkets?) -> ()) {
        get(.quotation(.marketAll)) { (data, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(try? UpbitMarkets(data: data))
        }
    }
    
    open func getCandle(_ type: CandleType,
                        market ticker: String,
                        to: String = "",
                        count: Int = 200,
                        convertingPriceUnit: String = "",
                        completion: @escaping (UpbitCandles?) -> ()) {
        var parameter = ["market": ticker, "to": to, "count": "\(count)"]
        if convertingPriceUnit != "" {
            parameter["convertingPriceUnit"] = convertingPriceUnit
        }
        get(.quotation(.candles(type)),
            query: parameter) { (data, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(try? UpbitCandles(data: data))
        }
    }
    
    open func getTradesTicks(market ticker: String,
                             to: String = "",
                             count: Int = 1,
                             cursor: String = "",
                             daysAgo: Int = 0,
                             completion: @escaping (UpbitTradeTicks?) -> ()) {
        var parameter = ["market": ticker,
                         "to": to,
                         "count": "\(count)",
                         "cursor": cursor]
        if daysAgo != 0 {
            parameter["daysAgo"] = "\(daysAgo)"
        }
        get(.quotation(.tradesTicks), query: parameter) { (data, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(try? UpbitTradeTicks(data: data))
        }
    }
    
    open func getTickers(market ticker: [String],
                        completion: @escaping(UpbitTickers?) -> ()) {
        get(.quotation(.ticker),
            query: ["markets": ticker.joined(separator: ",")]) { (data, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(try? UpbitTickers(data: data))
        }
    }
    
    open func getOrderbooks(market ticker: [String],
                            completion: @escaping(UpbitOrderBooks?) -> ()) {
        get(.quotation(.orderbook),
            query: ["markets": ticker.joined(separator: ",")]) { (data, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(try? UpbitOrderBooks(data: data))
        }
    }
}
