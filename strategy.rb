class Strategy
  attr_accessor :average_price, :last_price, :close_price_history, :refresh_rate_counter
  attr_accessor :risk, :avg_range, :refresh_rate

  def initialize(risk, avg_range, refresh_rate)
    self.average_price = nil
    self.last_price = nil
    self.refresh_rate_counter = 0
    self.close_price_history = []

    self.risk = risk
    self.avg_range = avg_range
    self.refresh_rate = refresh_rate
  end

  def can_buy?
    return false unless average_price
    last_price > risk * average_price if refresh_rate_counter = refresh_rate
  end

  def can_sell?
    return false unless average_price
    last_price < average_price if refresh_rate_counter = refresh_rate
  end

  def calculate_average_price
    return if close_price_history.size < avg_range
    self.average_price = close_price_history.sum / close_price_history.size
  end

  def clear_close_price_history
    until close_price_history.size <= avg_range do
      self.close_price_history = close_price_history.yield_self { |ary| ary.shift; ary }
    end
  end

  def reset_refresh_rate_counter
    self.refresh_rate_counter = 0 if refresh_rate_counter > refresh_rate
  end

  def upgrade(close_price, open_price)
    self.close_price_history << close_price
    self.last_price = open_price

    self.refresh_rate_counter += 1

    reset_refresh_rate_counter
    clear_close_price_history
    calculate_average_price
  end
end
