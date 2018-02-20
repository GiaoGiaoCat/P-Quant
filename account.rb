class Account
  attr_accessor :usdt_balance, :coin_balance

  def initialize
    self.usdt_balance = CAPITAL_BASE
    self.coin_balance = 0
  end

  def buy(price, count)
    return if usdt_balance <= price * count * 1.002
    self.usdt_balance -= price * count * 1.002
    self.coin_balance += count
  end

  def sell(price, count)
    return if coin_balance <= count
    self.usdt_balance += price * count * 0.998
    self.coin_balance -= count
  end

  def clearance(price)
  end
end
