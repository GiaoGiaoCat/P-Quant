#!/usr/bin/env ruby
require 'csv'
require './account'
require './strategy'

START_TIME = ""       # 回测起始时间
END_TIME = ""         # 回测结束时间
BENCHMARK = nil       # 策略参考标准
UNIVERSE = nil        # 证券池
CAPITAL_BASE = 5000   # 起始资金 USDT
REFRESH_RATE = 5      # 每隔 5 分钟调仓

# 策略描述
# 1. 获取历史数据
# 2. 每隔 5 分钟进行交割计算
# 3. 计算 30 分钟均价 average_price
# 4. 当前时段开盘价 > 1.0041 * average_price 则买入
# 5. 当前时段开盘价 < average_price 则清仓


# 初始化虚拟账户状态
def initialize_account
  @account = Account.new
end

# 初始化策略
def initialize_strategy
  @strategy = Strategy.new
end

def loopback_testing
  initialize_account
  initialize_strategy

  CSV.foreach('data.csv', headers: true) do |row|
    @strategy.upgrade row['close'].to_f, row['open'].to_f
    @account.buy row['open'].to_f, 1000 if @strategy.can_buy?
    @account.sell row['open'].to_f, 1000 if @strategy.can_sell?
    puts @strategy.average_price
    # @account.clearance if @strategy.can_sell?
  end
end

loopback_testing
puts @account.usdt_balance
puts @account.coin_balance
