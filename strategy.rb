class Strategy
  attr_accessor :average_price, :last_price, :close_price_history

  def initialize
    self.average_price = nil
    self.last_price = nil
    self.close_price_history = []
  end

  def can_buy?
    return false unless average_price
    last_price > 1.0041 * average_price
  end

  def can_sell?
    return false unless average_price
    last_price < average_price
  end

  def calculate_average_price
    self.average_price = close_price_history.sum / close_price_history.size
  end

  def clear_close_price_history
    until close_price_history.size <= 6 do
      self.close_price_history = close_price_history.yield_self { |ary| ary.shift; ary }
    end
  end

  def upgrade(close_price, open_price)
    self.close_price_history << close_price
    self.last_price = open_price

    if close_price_history.size >= 6
      clear_close_price_history
      calculate_average_price
    end
  end
end
