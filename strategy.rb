class Strategy
  attr_accessor :average_price, :last_price, :close_price_history, :risk, :avg_range

  def initialize(risk, avg_range)
    self.average_price = nil
    self.last_price = nil
    self.close_price_history = []
    self.risk = risk
    self.avg_range = avg_range
  end

  def can_buy?
    return false unless average_price
    last_price > risk * average_price
  end

  def can_sell?
    return false unless average_price
    last_price < average_price
  end

  def calculate_average_price
    return if close_price_history.size < avg_range
    self.average_price = close_price_history.sum / close_price_history.size
    puts "calculate_average_price #{average_price}"
  end

  def clear_close_price_history
    until close_price_history.size <= avg_range do
      self.close_price_history = close_price_history.yield_self { |ary| ary.shift; ary }
      puts "clear_close_price_history #{close_price_history}"
    end
  end

  def upgrade(close_price, open_price)
    self.close_price_history << close_price
    self.last_price = open_price

    clear_close_price_history
    calculate_average_price
  end
end
