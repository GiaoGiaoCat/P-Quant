# P-Quant

## CryptoCompare API

### V1

* CoinList 获取货币列表，主要是拿到 `Data[Symbol]:Id` 方便后续调用其它 API
* Price 最新价格数据
* PriceHistorical 获取某一时间点的指定数字货币对应不同货币单位的价格，例如 `{"ETH":{"BTC":0.00261,"USD":1.14,"EUR":1.04}}`
* CoinSnapshot 不太清楚干啥的，解释是 Get data for a currency pair，官方说该 API 被滥用
* CoinSnapshotFullById 没看懂
* SocialStats 从网络上获取基本面信息，暂时用不上
* HistoMinute 以分钟为单位获取技术面数据（开盘，收盘，最高，最低，成交量）
* HistoHour
* HistoDay
* MiningContracts 用不上
* MiningEquipment 用不上
* TopPairs 获取交易量

### V2

https://min-api.cryptocompare.com/

* Single 单一币的实时价格
* Multi 多个币的实时价格
* PriceHistorical 指定时间点的历史价格
* MultiFull **获取指定货币的 price, vol, open, high, low 等数据**
* GenerateAvg 根据几个交易所的算出平均的 price, vol, open, high, low 等数据
* DayAvg 算一天的平均值
* SubsWatchlist
* Subs 获取哪些交易所可以进行指定数字货币什么类型的交易，比如查询 IOST 发现可以在 huobi 进行 USDT BTC ETH 交易
* TopExchanges 按过去24小时的交易数量列出交易所
* TopExchangesFull **不但获得过去24小时的交易数量，还返回了 CCCAGG 数据**
* TopVolumes 24小时内交易量最多的货币列表
* TopPairs
* TopCoinsByTotalVol
* AllExchanges 所有交易所可用的交易对
* AllCoinsWithContent 站点所有以监控的 Coin
* AllNewsProviders 基本面信息相关
* News 基本面信息
* HistoDay
* HistoHour
* HistoMinute **以分钟为单位获取7天内的基本面信息**

## IOST

这里只要 ID 有用，是调用其它 API 的参数。

```json
"IOST": {
  "Id": "716522",
  "Url": "/coins/iost/overview",
  "ImageUrl": "/media/27010459/iost.png",
  "Name": "IOST",
  "Symbol": "IOST",
  "CoinName": "IOS token",
  "FullName": "IOS token (IOST)",
  "Algorithm": "N/A",
  "ProofType": "N/A",
  "FullyPremined": "0",
  "TotalCoinSupply": "21000000000",
  "PreMinedValue": "N/A",
  "TotalCoinsFreeFloat": "N/A",
  "SortOrder": "2148",
  "Sponsored": false,
  "IsTrading": true
},
```

## 运行

在命令行下面先执行 `chmod +x demo.rb` 再执行 `./demo.rb`
