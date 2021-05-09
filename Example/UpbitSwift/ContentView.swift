//
//  ContentView.swift
//  UpbitSwift_Example
//
//  Created by ocean on 2021/03/14.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import UpbitSwift

struct ContentView: View {
    @State var marketList = UpbitMarketList()
    var upbitSwift = UpbitSwift()
    
    var body: some View {
        NavigationView {
            TabView {
                List(marketList.filter({ $0.market.contains("KRW-") }), id: \.market) { market in
                    NavigationLink(destination: MarketDetailView(ticker: market.market, name: market.koreanName)) {
                        MarketListRow(market: market)
                    }
                }
                .tabItem { Label("KRW", image: "won").aspectRatio(contentMode: .fill) }
                
                List(marketList.filter({ $0.market.contains("BTC-") }), id: \.market) { market in
                    NavigationLink(destination: MarketDetailView(ticker: market.market, name: market.koreanName)) {
                        MarketListRow(market: market)
                    }
                }
                .tabItem { Label("BTC", image: "bitcoin").aspectRatio(contentMode: .fill) }
                
                List(marketList.filter({ $0.market.contains("USDT-") }), id: \.market) { market in
                    NavigationLink(destination: MarketDetailView(ticker: market.market, name: market.koreanName)) {
                        MarketListRow(market: market)
                    }
                }
                .tabItem { Label("USDT", image: "dollar").aspectRatio(contentMode: .fill) }
            }
            .navigationTitle("Upbit Market")
        }
        .onAppear() {
            upbitSwift.getMarketAll(isDetails: false) { result in
                switch result {
                case .success(let marketList):
                    if let marketList = marketList {
                        self.marketList = marketList
                    }
                case .failure(let error):
                    print(error.failureReason ?? "Not found error")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
