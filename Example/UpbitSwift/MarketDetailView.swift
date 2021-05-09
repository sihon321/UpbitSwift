//
//  MarketDetailView.swift
//  UpbitSwift_Example
//
//  Created by ocean on 2021/03/14.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import UpbitSwift

struct MarketDetailView: View {
    @State var currentTicker: UpbitTicker?
    @State var isBull: Bool = false
    @State var ratio: Double = 0.0
    
    let ticker: String
    let name: String
    var upbitSwift = UpbitSwift()
    
    var price: String {
        if currentTicker?.market.contains("KRW-") ?? false {
            return "₩" + String(format: "%.1f", currentTicker?.tradePrice ?? 0)
        } else if currentTicker?.market.contains("BTC-") ?? false {
            return "BTC \(currentTicker?.tradePrice ?? 0)"
        } else if currentTicker?.market.contains("USDT-") ?? false {
            return "$" + String(format: "%.3f", currentTicker?.tradePrice ?? 0)
        }
        return "0.0"
    }
    
    var signedPrice: String {
        if currentTicker?.market.contains("KRW-") ?? false {
            return String(format: "%.1f", currentTicker?.signedChangePrice ?? 0) + "₩"
        } else if currentTicker?.market.contains("BTC-") ?? false {
            return ""
        } else if currentTicker?.market.contains("USDT-") ?? false {
            return String(format: "%.3f", currentTicker?.signedChangePrice ?? 0) + "$"
        }
        return "0.0"
    }
    
    var body: some View {
        VStack {
            Text(name).font(.title)
            Text(currentTicker?.market ?? "").font(.body)
            Spacer().frame(height: 50)
            Text(price).font(.largeTitle)
            Text("시가 \(price)").font(.caption)
            Spacer().frame(height: 20)
            HStack {
                Text("\(String(format: "%.2f", ratio))%")
                    .font(.subheadline)
                    .foregroundColor(isBull ? .red : .blue)
                Text(signedPrice)
                    .font(.subheadline)
                    .foregroundColor(isBull ? .red : .blue)
            }
            Spacer().frame(height: 50)
            Button(action: {
                requestTicker(ticker)
            }) {
                Text("Refresh")
            }
        }
        .onAppear() {
            requestTicker(ticker)
        }
    }
    
    private func requestTicker(_ ticker: String) {
        upbitSwift.getTickers(market: [ticker]) { result in
            switch result {
            case .success(let tickers):
                if let ticker = tickers?.first {
                    self.currentTicker = ticker
                    self.ratio = round(ticker.signedChangeRate * 10000) / 100
                    self.isBull = self.ratio > 0.0
                }
            case .failure(let error):
                print(error.failureReason ?? "Not found error")
            }
        }
    }
}

struct MarketDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MarketDetailView(ticker: "KRW-BTC", name: "비트코인")
    }
}
