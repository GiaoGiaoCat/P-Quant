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
def initialize_strategy(risk)
  @strategy = Strategy.new(risk)
end

def loopback_testing(risk)
  initialize_account
  initialize_strategy(risk)

  CSV.foreach('data.csv', headers: true) do |row|
    @account.buy row['open'].to_f, 1000 if @strategy.can_buy?
    @account.sell row['open'].to_f, 1000 if @strategy.can_sell?
    @strategy.upgrade row['close'].to_f, row['open'].to_f
  end

  clearance
  display_testing_result
end

def clearance
  @account.clearance @strategy.last_price
end

def display_testing_result
  puts "Money: #{@account.usdt_balance} Risk: #{@strategy.risk}"
end

function_time = Benchmark.realtime do
  (0.95...1.02).step(0.001).each do |risk|
    loopback_testing(risk)
  end
end

puts "Run time: #{function_time} seconds."
