class Account
  CAPITAL_BASE = 5000 # 起始资金 USDT

  attr_accessor :usdt_balance, :coin_balance, :account_book

  def initialize(account_book)
    self.usdt_balance = CAPITAL_BASE
    self.coin_balance = 0
    self.account_book = account_book
  end

  def buy(strategy)
    return if usdt_balance <= strategy.last_price.to_f * 1.001
    amount =
      if coin_balance == 0
        ((usdt_balance / 10) / strategy.last_price.to_f)
      else
        ((usdt_balance / 20) / strategy.last_price.to_f)
      end
    self.usdt_balance -= strategy.last_price.to_f * amount * 1.001
    self.coin_balance += amount
    log strategy, "In", amount
  end

  def clearance(strategy)
    return if coin_balance == 0
    cache_coin_balance = coin_balance
    self.usdt_balance += strategy.last_price.to_f * coin_balance * 0.999
    self.coin_balance = 0
    log strategy, "Out", cache_coin_balance
  end

  def log(strategy, type, count = 1000)
    price = strategy.last_price
    time = DateTime.strptime(strategy.time,'%s').to_s
    account_book.puts "#{time},#{type},#{strategy.average_price_1.round(5)},#{strategy.average_price_2.round(5)},#{price},#{count.round(4)},#{(price * count).round(5)},#{(price * count * 0.001).round(4)},#{usdt_balance.round(5)},#{coin_balance.round(5)},#{(usdt_balance+(price*coin_balance)).round(5)}"
  end

end
