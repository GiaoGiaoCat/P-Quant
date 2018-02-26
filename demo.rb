#!/usr/bin/env ruby
require 'csv'
# require 'benchmark'
# require 'parallel'
require './account'
require './strategy'
require './strategy_bak'

# 初始化虚拟账户状态
def initialize_account(account_book)
  @account = Account.new(account_book)
end

# 初始化策略
def initialize_strategy(risk, avg_range_1, avg_range_2, refresh_rate)
  @strategy = StrategyBak.new(risk, avg_range_1, avg_range_2, refresh_rate)
end

def loopback_testing(account_book, risk, avg_range_1, avg_range_2, refresh_rate)
  initialize_account(account_book)
  initialize_strategy(risk, avg_range_1, avg_range_2, refresh_rate)

  CSV.foreach('data.csv', headers: true) do |row|
    @strategy.upgrade row['time'], row['close'].to_f, row['open'].to_f
    @account.buy @strategy if @strategy.can_buy?
    # @account.sell row['open'].to_f, 1000 if @strategy.can_sell?
    @account.clearance @strategy if @strategy.can_sell?
  end

  clearance
  display_testing_result
end

def clearance
  @account.clearance @strategy
end

def display_testing_result
  if @account.usdt_balance > Account::CAPITAL_BASE
    puts "Money: #{@account.usdt_balance} Risk: #{@strategy.risk} Avg_range: #{@strategy.avg_range}"
  end
end

# Plan 1: 买入：P>Avg(n)，卖出P<Avg(n)，for n from 5 to 120
# risks = (1.0041..1.02).step(0.001).to_a.each do |risk|
#   avg_ranges = (5..120).to_a
#   # refresh_rates = (1..15).to_a
#   avg_ranges.each do |avg_range|
#     File.open("plan_1_d/#{avg_range}_#{risk}.csv", 'w+') do |file|
#       file.puts '时间,交易类型,平均价,当前交易价,交易数量,交易金额,手续费,USDT,COIN'
#       loopback_testing(file, risk, avg_range, 5)
#     end
#   end
# end




# end

# Plan 1: 买入：P>avg(n) and P>avg(m), m < n, 卖出：P<avg(m)
File.open("demo2.csv", 'w+') do |file|
  file.puts '时间,交易类型,平均价1,平均价2,当前交易价,交易数量,交易金额,手续费,USDT,COIN,Net_Value'
  loopback_testing(file, 1.01, 120, 30, 1)
end
