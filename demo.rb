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

def loopback_testing(account_book, risk, avg_range_1, avg_range_2, refresh_rate, data_file)
  initialize_account(account_book)
  initialize_strategy(risk, avg_range_1, avg_range_2, refresh_rate)

  CSV.foreach(data_file, headers: true) do |row|
    @strategy.upgrade row['time'], row['close'].to_f, row['open'].to_f
    if @strategy.can_buy?
      @account.buy @strategy
      @strategy.start_log_offsets = true
    end
    # @account.sell row['open'].to_f, 1000 if @strategy.can_sell?
    if @strategy.can_sell?
      @account.clearance @strategy
      @strategy.start_log_offsets = false
    end
  end

  clearance
  display_testing_result
end

def clearance
  @account.clearance @strategy
end

def display_testing_result
  if @account.usdt_balance > Account::CAPITAL_BASE
    puts "#{@account.usdt_balance.round(2)},#{@strategy.risk},#{@strategy.avg_range_1},#{@strategy.avg_range_2}"
  end
end

# Plan 1: 买入：P>Avg(n)，卖出P<Avg(n)，for n from 5 to 120
# risks = (0.99..1.06).step(0.01).to_a.each do |risk|
#   avg_range_2 = (5..2400).step(15).to_a.each do |avg_range_2|
#     avg_range_1 = (90..7500).step(15).to_a.each do |avg_range_1|
#     # refresh_rates = (1..15).to_a
#     # avg_ranges.each do |avg_range|
#     #File.open("plan_1_d/#{avg_range_1}_#{avg_range_2}.csv", 'w+') do |file|
#     #file.puts '时间,交易类型,平均价,当前交易价,交易数量,交易金额,手续费,USDT,COIN,Net_Value'
#       loopback_testing(@account, risk, avg_range_1, avg_range_2, 1)
#     end
#   end
#  end

# NOTE: 2月27日 策略
# 买入：P>avg(m) and avg(m)>avg(n) and m < n
# 卖出：P<avg(m)
# %w[btc dta eth iost].each do |data_file|
%w[iost].each do |data_file|
  fork do
    File.open("log/#{data_file}_log.csv", 'w+') do |file|
      puts "Working on #{data_file}"
      file.puts '时间,交易类型,平均价1,平均价2,当前交易价,交易数量,交易金额,手续费,USDT,COIN,Net_Value'
      loopback_testing(file, 1, 3000, 30, 1, "data/#{data_file}.csv")
    end
  end
end
Process.wait
