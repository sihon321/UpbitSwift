//
//  ExchangeAPI.swift
//  upbit-swift
//
//  Created by ocean on 2021/03/10.
//

import Foundation

public enum ExchangeAPI {
    case asset(AssetAPI), order(OrderAPI), withdraw(WithdrawAPI), deposit(DepositAPI), info(InfoAPI)
}

extension ExchangeAPI {    
    var path: String {
        switch self {
        case .asset(let api): return api.path
        case .order(let api): return api.path
        case .withdraw(let api): return api.path
        case .deposit(let api): return api.path
        case .info(let api): return api.path
        }
    }
}

public enum AssetAPI {
    case allAccounts
}

extension AssetAPI {
    var path: String {
        switch self {
        case .allAccounts: return "/accounts"
        }
    }
}

public enum OrderAPI {
    case ordersChance, searchOrder, searchOrders, deleteOrder, order
}

extension OrderAPI {
    var path: String {
        switch self {
        case .ordersChance: return "/orders/chance"
        case .searchOrder, .deleteOrder: return "/order"
        case .searchOrders, .order: return "/orders"
        }
    }
}

public enum MarketPosition: String {
    case buy = "bid", sell = "ask"
}

public enum WithdrawAPI {
    case searchList, search, withdrawsChance, coin, krw
}

extension WithdrawAPI {
    var path: String {
        switch self {
        case .searchList: return "/withdraws"
        case .search: return "/withdraw"
        case .withdrawsChance: return "/withdraws/chance"
        case .coin: return "/withdraws/coin"
        case .krw: return "/withdraws/krw"
        }
    }
}

public enum DepositAPI {
    case searchList, search, generateCoinAddress, searchCoinAddressList,
         searchCoinAddress, krw
}

extension DepositAPI {
    var path: String {
        switch self {
        case .searchList: return "/deposits"
        case .search: return "/search"
        case .generateCoinAddress: return "/deposits/generate_coin_address"
        case .searchCoinAddressList: return "/deposits/coin_addresses"
        case .searchCoinAddress: return "/deposits/coin_address"
        case .krw: return "/deposits/krw"
        }
    }
}

public enum InfoAPI {
    case walletStatus, apiKeys
}

extension InfoAPI {
    var path: String {
        switch self {
        case .walletStatus: return "/status/wallet"
        case .apiKeys: return "/api_keys"
        }
    }
}

public enum UpbitMethod {
    case get, delete
}
