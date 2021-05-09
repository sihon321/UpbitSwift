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
             completion: @escaping (AFDataResponse<Data>) -> ()) {
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
                completion(response)
            }
    }
    
    func get(_ api: UpbitAPI,
             query parameter: [String: String],
             arrayQuery arrayParameter: [String: [String]],
             completion: @escaping (AFDataResponse<Data>) -> ()) {
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
                completion(response)
            }
    }
    
    func post(_ api: UpbitAPI,
              body parameter: [String: String],
              completion: @escaping (AFDataResponse<Data>) -> ()) {
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
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
                completion(response)
            }
    }
    
    func delete(_ api: UpbitAPI,
                query parameter: [String: String]? = nil,
                completion: @escaping (AFDataResponse<Data>) -> ()) {
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
        
        AF.request(api.baseURL + api.path, method: .delete, parameters: parameter, headers: headers)
            .responseData { response in
                completion(response)
            }
    }
}

// MARK: - QuotationAPI
extension UpbitSwift {
    open func getMarketAll(isDetails: Bool,
                           completion: @escaping (Result<UpbitMarketList?, AFError>) -> ()) {
        get(.quotation(.marketAll)) { response in
            switch response.result {
            case .success(let data):
                completion(.success(try? UpbitMarketList(data: data)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    open func getCandle(_ type: CandleType,
                        market ticker: String,
                        to: String = "",
                        count: Int = 200,
                        convertingPriceUnit: String = "",
                        completion: @escaping (Result<UpbitCandles?, AFError>) -> ()) {
        var parameter = ["market": ticker, "to": to, "count": "\(count)"]
        if convertingPriceUnit != "" {
            parameter["convertingPriceUnit"] = convertingPriceUnit
        }
        get(.quotation(.candles(type)),
            query: parameter) { response in
            switch response.result {
            case .success(let data):
                completion(.success(try? UpbitCandles(data: data)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    open func getTradesTicks(market ticker: String,
                             to: String = "",
                             count: Int = 1,
                             cursor: String = "",
                             daysAgo: Int = 0,
                             completion: @escaping (Result<UpbitTradeTicks?, AFError>) -> ()) {
        var parameter = ["market": ticker,
                         "to": to,
                         "count": "\(count)",
                         "cursor": cursor]
        if daysAgo != 0 {
            parameter["daysAgo"] = "\(daysAgo)"
        }
        
        get(.quotation(.tradesTicks), query: parameter) { response in
            switch response.result {
            case .success(let data):
                completion(.success(try? UpbitTradeTicks(data: data)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    open func getTickers(market ticker: [String],
                        completion: @escaping(Result<UpbitTickers?, AFError>) -> ()) {
        get(.quotation(.ticker),
            query: ["markets": ticker.joined(separator: ",")]) { response in
            switch response.result {
            case .success(let data):
                completion(.success(try? UpbitTickers(data: data)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    open func getOrderbooks(market ticker: [String],
                            completion: @escaping (Result<UpbitOrderBooks?, AFError>) -> ()) {
        get(.quotation(.orderbook),
            query: ["markets": ticker.joined(separator: ",")]) { response in
            switch response.result {
            case .success(let data):
                completion(.success(try? UpbitOrderBooks(data: data)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - ExchangeAPI - Asset
extension UpbitSwift {
    
    // 전체 계좌 조회
    open func getAccounts(completion: @escaping (Result<UpbitAccounts?, AFError>) -> ()) {
        get(.exchange(.asset(.allAccounts))) { response in
            switch response.result {
            case .success(let data):
                completion(.success(try? UpbitAccounts(data: data)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - ExchangeAPI - Exchange
extension UpbitSwift {
    
    // 주문 가능 정보
    open func getOrdersChance(market ticker: String,
                              completion: @escaping (Result<UpbitOrdersChance?, AFError>) -> ()) {
        get(.exchange(.order(.ordersChance)), query: ["market": ticker]) { response in
            switch response.result {
            case .success(let data):
                completion(.success(try? UpbitOrdersChance(data: data)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 개별 주문 조회, 주문 취소 접수
    open func requestOrder(_ method: UpbitMethod,
                           uuid: String,
                           identifier: String = "",
                           completion: @escaping (Result<UpbitOrder?, AFError>) -> ()) {
        var parameter = ["uuid": uuid]
        if identifier != "" {
            parameter["identifier"] = identifier
        }
        
        switch method {
        case .get:
            get(.exchange(.order(.searchOrder)),
                query: parameter) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(try? UpbitOrder(data: data)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case .delete:
            delete(.exchange(.order(.deleteOrder)),
                   query: parameter) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(try? UpbitOrder(data: data)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // 주문 리스트 조회
    open func getOrders(market ticker: String,
                        state: String,
                        states: [String] = [],
                        uuids: [String],
                        identifiers: [String] = [],
                        page: Int = 1,
                        limit: Int = 100,
                        orderBy: String = "desc",
                        completion: @escaping (Result<UpbitOrders?, AFError>) -> ()) {
        var arrayParameter = ["uuids[]": uuids]
        if states.isEmpty == false {
            arrayParameter["states[]"] = states
        }
        if identifiers.isEmpty == false {
            arrayParameter["identifiers[]"] = identifiers
        }
        get(.exchange(.order(.searchOrders)),
            query: ["market": ticker,
                    "state": state,
                    "page": "\(page)",
                    "limit": "\(limit)",
                    "order_by": orderBy],
            arrayQuery: arrayParameter) { response in
            switch response.result {
            case .success(let data):
                completion(.success(try? UpbitOrders(data: data)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 주문하기
    open func order(_ side: MarketPosition,
                    market ticker: String,
                    volume: String = "",
                    price: String = "",
                    identifier: String = "",
                    completion: @escaping (Result<UpbitOrder?, AFError>) -> ()) {
        var parameter = ["market": ticker,
                         "side": side.rawValue]

        if side == .buy && volume == "" && price != "" {
            parameter["ord_type"] = "price"
            parameter["price"] = price
        } else if side == .sell && volume != "" && price == "" {
            parameter["ord_type"] = "market"
            parameter["volume"] = volume
        } else if volume != "" && price != "" {
            parameter["ord_type"] = "limit"
            parameter["price"] = price
            parameter["volume"] = volume
        }

        if identifier != "" {
            parameter["identifier"] = identifier
        }
        post(.exchange(.order(.order)), body: parameter) { response in
            switch response.result {
            case .success(let data):
                completion(.success(try? UpbitOrder(data: data)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
