#!/usr/bin/env ruby
require 'csv'
require 'benchmark'
require 'progress_bar'
require './account'
require './strategy'

bar = ProgressBar.new

# 初始化虚拟账户状态
def initialize_account
  @account = Account.new
end

# 初始化策略
def initialize_strategy(risk, avg_range, refresh_rate)
  @strategy = Strategy.new(risk, avg_range, refresh_rate)
end

def loopback_testing(risk, avg_range, refresh_rate)
  initialize_account
  initialize_strategy(risk, avg_range, refresh_rate)

  CSV.foreach('data.csv', headers: true) do |row|
    @account.buy row['open'].to_f, 1000 if @strategy.can_buy?
    # @account.sell row['open'].to_f, 1000 if @strategy.can_sell?
    @account.clearance row['open'].to_f if @strategy.can_sell?
    @strategy.upgrade row['close'].to_f, row['open'].to_f
  end

  clearance
  display_testing_result
end

def clearance
  @account.clearance @strategy.last_price
end

def display_testing_result
  if @account.usdt_balance > Account::CAPITAL_BASE
    puts "Money: #{@account.usdt_balance} Risk: #{@strategy.risk} Avg_range: #{@strategy.avg_range}"
  end
end

# Plan 1: 买入价系数从 0.095 到 1.02 之间
# function_time = Benchmark.realtime do
#   n = 0
#   (0.95...1.02).step(0.001).each do |risk|
#     n += 1
#     loopback_testing(risk, 6, 6)
#   end
#   puts "共测试 #{n} 个组合"
# end

# Plan 2：平均值计算范围从 5min 到 120min
# function_time = Benchmark.realtime do
#   (5...120).each do |avg_range|
#     loopback_testing(1.0041, avg_range)
#   end
# end

# Plan 3：高频交易每分钟1次，组合买入价系数 从 1.0041 到 1.02 之间，平均值计算范围从 5min 到 10min，每隔 5 分钟交易
function_time = Benchmark.realtime do
  (1.0041...1.2).step(0.001).each do |risk|
    (5...10).each do |avg_range|
      loopback_testing(risk, avg_range, 5)
    end
  end
end

puts "Run time: #{function_time} seconds."
