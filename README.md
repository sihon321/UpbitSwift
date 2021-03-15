# UpbitSwift

[![CI Status](https://img.shields.io/travis/sihon321/UpbitSwift.svg?style=flat)](https://travis-ci.org/sihon321/UpbitSwift)
[![Version](https://img.shields.io/cocoapods/v/UpbitSwift.svg?style=flat)](https://cocoapods.org/pods/UpbitSwift)
[![License](https://img.shields.io/cocoapods/l/UpbitSwift.svg?style=flat)](https://cocoapods.org/pods/UpbitSwift)
[![Platform](https://img.shields.io/cocoapods/p/UpbitSwift.svg?style=flat)](https://cocoapods.org/pods/UpbitSwift)

Swift Wrapper For Upbit API

## Example

<img src = "https://user-images.githubusercontent.com/12742588/111182826-a6166f00-85f2-11eb-9b09-3b1773792daf.png" width="200px"> <img src = "https://user-images.githubusercontent.com/12742588/111182724-897a3700-85f2-11eb-8c03-3af7b336dabd.png" width="200px"> 

To run the example SwiftUI project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Swift 5.0+
- iOS 11.0+

## Installation

### CocoaPods

UpbitSwift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'UpbitSwift'
```

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/sihon321/UpbitSwift.git")
]
```

## Usage

### QUOTATION API

- 시세 종목 조회
```swift
    let upSwift = UpbitSwift()
    let marketList = UpbitMarketList()
    
    upSwift.getMarketAll(isDetails: false) { (marketList, error) in
            self.marketList = marketList
    }
```
- 시세 캔들 조회

캔들 조회는 getCandle() 함수 하나로 정의 할수 있습니다. 각 캔들은 enum으로 되어있고 원하는 캔들을 선택하시면 됩니다.
```swift
    let upSwift = UpbitSwift()
    let candles = UpbitCandles()
    upbitSwift.getCandle(.minute(.one), market: "KRW-BTC") { candles, error in
        self.candles = candles
    }
```

```swift
    public enum CandleType {
        case minute(MinuteCandle)
        case hour(HourCandle)
        case days
        case weeks
        case months
    }

    public enum MinuteCandle: Int {
        case one = 1
        case three = 3
        case five = 5
        case ten = 10
        case fifteen = 15
        case thirty = 30
    }

    public enum HourCandle: Int {
        case one = 60
        case four = 240
    }
```

    
- 시세 Ticker 조회

```swift
    let upSwift = UpbitSwift()
    let tickers = UpbitTickers()
    upbitSwift.getTickers(market: ["KRW-BTC"]) { tickers, error in
        self.tickers = tickers
    }
```

### EXCHANGE API

- 전체 계좌 조회
```swift
    let upSwift = UpbitSwift()
    let accounts = UpbitAccounts()
    upbitSwift.getAccounts() { accounts, error in
        self.accounts = accounts
    }
```

- 개별 주문 조회, 주문 취소 접수
```swift
    let upSwift = UpbitSwift()
    let order = UpbitOrder()
    upbitSwift.requestOrder(.get, 
                            uuid: "5b72488b-fa82-4012-a9a4-7093cd529a16") { order, error in
        self.order = order
    }
```
    주문 취소 접수 시 method를 delete로 변경하면 됩니다.
    
- 주문 하기

지정가 매수 시: volume, price 모두 입력
```swift
    let upSwift = UpbitSwift()
    let order = UpbitOrder()
    upbitSwift.order(.buy, market: "KRW-BTC", volume: "0.001", price: "1000.0") { order, error in
        self.order = order
    }
```

시장가 매수 시: price 만 입력
```swift
    let upSwift = UpbitSwift()
    let order = UpbitOrder()
    upbitSwift.order(.buy, market: "KRW-BTC", price: "1000.0") { order, error in
        self.order = order
    }
```

지정가 매도 시: volume, price 모두 입력
```swift
    let upSwift = UpbitSwift()
    let order = UpbitOrder()
    upbitSwift.order(.sell, market: "KRW-BTC", volume: "0.001", price: "1000.0") { order, error in
        self.order = order
    }
```

시장가 매도 시: volume 만 입력
```swift
    let upSwift = UpbitSwift()
    let order = UpbitOrder()
    upbitSwift.order(.sell, market: "KRW-BTC", volume: "0.001") { order, error in
        self.order = order
    }
```
    
## Author

sihon321, sihon321@daum.net

## License

UpbitSwift is available under the MIT license. See the LICENSE file for more info.
