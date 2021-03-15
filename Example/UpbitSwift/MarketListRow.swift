//
//  MarketListRow.swift
//  UpbitSwift_Example
//
//  Created by ocean on 2021/03/14.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import UpbitSwift

struct MarketListRow: View {
    @State var market: UpbitMarket
    
    var body: some View {
        HStack {
            Text(market.market).font(.subheadline)
            Text(market.koreanName).font(.title)
        }
    }
}

struct MarketListRow_Previews: PreviewProvider {
    static var previews: some View {
        let jsonString = "{\"market\":\"KRW-BTC\",\"korean_name\":\"비트코인\",\"english_name\":\"Bitcoin\"}"
        if let market = try? UpbitMarket(jsonString) {
            MarketListRow(market: market)
        }
    }
}
