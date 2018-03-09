require 'date'
class StrategyBak
  attr_accessor :time, :last_price, :refresh_rate_counter
  attr_accessor :average_price_1, :average_price_2
  attr_accessor :close_price_history_1, :close_price_history_2
  attr_accessor :risk, :avg_range_1, :avg_range_2, :refresh_rate

  def initialize(risk, avg_range_1, avg_range_2, refresh_rate)
    self.average_price_1 = nil # 3000 均线
    self.average_price_2 = nil # 30 均线
    self.last_price = nil
    self.refresh_rate_counter = 0
    self.close_price_history_1 = []
    self.close_price_history_2 = []
    self.time = nil

    self.risk = risk
    self.avg_range_1 = avg_range_1
    self.avg_range_2 = avg_range_2
    self.refresh_rate = refresh_rate
  end

  def can_buy?
    return false unless average_price_1
    return false unless average_price_2
    if refresh_rate_counter == refresh_rate
      (last_price > risk * average_price_2) && (average_price_1 < average_price_2)
    end
  end

  def can_sell?
    return false unless average_price_1 && average_price_2
    if refresh_rate_counter == refresh_rate
      last_price < (risk * average_price_2)
    end
  end

  def calculate_average_price
    return if close_price_history_1.size < avg_range_1
    return if close_price_history_2.size < avg_range_2
    self.average_price_1 = close_price_history_1.sum / close_price_history_1.size
    self.average_price_2 = close_price_history_2.sum / close_price_history_2.size
  end

  def clear_close_price_history
    until close_price_history_1.size <= avg_range_1
      self.close_price_history_1 = close_price_history_1.yield_self { |ary| ary.shift; ary }
    end
    until close_price_history_2.size <= avg_range_2
      self.close_price_history_2 = close_price_history_2.yield_self { |ary| ary.shift; ary }
    end
  end

  def reset_refresh_rate_counter
    self.refresh_rate_counter = 0 if refresh_rate_counter > refresh_rate
  end

  def upgrade(time, close_price, open_price)
    self.time = time
    close_price_history_1 << close_price
    close_price_history_2 << close_price
    self.last_price = open_price

    reset_refresh_rate_counter
    self.refresh_rate_counter += 1

    clear_close_price_history
    calculate_average_price
  end

end
