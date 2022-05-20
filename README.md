# fugle-realtime-swift

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FKeanuPang%2Ffugle-realtime-swift%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/KeanuPang/fugle-realtime-swift)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FKeanuPang%2Ffugle-realtime-swift%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/KeanuPang/fugle-realtime-swift)
![license](https://img.shields.io/github/license/KeanuPang/fugle-realtime-swift)


The Swift implementation for Fugle Realtime API client.

* [x] HTTP API
* [x] Websocket API
* [x] Async/Await support

## Installation

Add `fugle-realtime-swift` as a dependency for your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/KeanuPang/fugle-realtime-swift.git", .upToNextMajor(from: "0.1.1"))
]
```

Add dependency for you target in `Package.swift`:

```swift
dependencies: [
 .product(name: "FugleRealtime", package: "fugle-realtime-swift")
]
```

## Quick demo

Query Intraday meta data by symbol `2884` via HTTP:

```swift
import FugleRealtime

do {
    if let result = try await client.getIntraday(MetaData.self, symbol: "2884") {
        print("\(result.toJSONString(prettyPrint: true) ?? "")")

        if let metaData = result.meta {
            print("name: \(metaData.nameZhTw ?? "")")
            print("priceReference: \(metaData.priceReference?.stringValue ?? "")")
            
            /// will print:
            /// name: 玉山金
            /// priceReference: 29.6
        }
    }

    client.shutdownWS()
} catch {}
```

Subscribe Intraday quote data by symbol `2884` realtime via Websocket:

```swift
import FugleRealtime

var promise: EventLoopPromise<Void>?

// Prepare your callback function for quote data
let quoteDataCallback: ((Result<QuoteData, ClientError>) -> Void) = {
    switch $0 {
    case .success(let result):
        print("\(result.quote?.priceAvg?.price?.stringValue ?? ""), \(result.quote?.priceAvg?.at ?? "")")
    case .failure(let failures):
        promise?.fail(failures)
    }
}

// connect and subscribe intraday websocket endpoint
do {
    promise = try await client.streamIntraday(QuoteData.self, symbol: "2884", callback: quoteDataCallback)
    try promise?.futureResult.wait()
} catch {
    client.shutdownWS()
}
```


## Usage

Pass your API token to `FugleClient`:

```swift
let token = "demo"
let client = FugleClient = FugleClient.initWithApiToken(demo)
```

Or you can put `.env` file into working folder that contains the following enviroment variables declaration:

```
FUGLE_API_TOKEN=demo
```

Now your could use FugleClient directly without passing token parameter:

```swift
let client = FugleClient.shared
```

Calling intraday resource via HTTP endpoint, just pass the `Mapped` data class to `getIntraday()` function:

```swift
let response: MetaData? = try await client.getIntraday(MetaData.self, symbol: "2884")
```

If you would like to get dealts data with paging via HTTP endpoint, you can call `getIntradayDealts()` function:

```swift
let response: DealtsData? = try await client.getIntradayDealts(symbol: "2884", pagingLimit: 10)
```


### Intraday Resource:

Type   |Mapped Data Class
-------|------------------
Meta   |MataData
Quote  |QuoteData
Chart  |ChartData
Dealts |DealtsData
Volumes|VolumesData

For historical stock data, just call `getMarketData()` function:

```swift
let response: CandleData? = try await client.getMarketData(symbol: "2884", from: "2022-04-25", to: "2022-04-29")
```

### Marketdata Resource:

Type   |Mapped Data Class
-------|------------------
Candles|CandleData



## Bug Report
If you hit any issues while using this SDK, please bug reports on GitHub issue.
