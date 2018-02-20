#!/usr/bin/env ruby
require 'csv'
require 'benchmark'
require './account'
require './strategy'

# 初始化虚拟账户状态
def initialize_account
  @account = Account.new
end

# 初始化策略
def initialize_strategy(risk, avg_range)
  @strategy = Strategy.new(risk, avg_range)
end

def loopback_testing(risk, avg_range)
  initialize_account
  initialize_strategy(risk, avg_range)

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
  puts "Money: #{@account.usdt_balance} Risk: #{@strategy.risk} Avg_range: #{@strategy.avg_range}"
end

# Plan 1: 买入价系数从 0.095 到 1.02 之间
# function_time = Benchmark.realtime do
#   (0.95...1.02).step(0.001).each do |risk|
#     loopback_testing(risk)
#   end
# end

# Plan 2：平均值计算范围从 1x5min 到 12x5min
function_time = Benchmark.realtime do
  (2...12).each do |avg_range|
    loopback_testing(1.0041, avg_range)
  end
end

puts "Run time: #{function_time} seconds."
