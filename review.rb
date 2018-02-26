require 'csv'
require 'time'

#胜率=盈利的平仓次数/总平仓次数
def win_rate
buyin_number=0
previous_net_value =5000
win_number=0
lose_number=0

CSV.foreach("demo.csv", :headers =>true) do |row|  
	if row['交易类型'] == 'In' then buyin_number = buyin_number +1 
	else 
		if row['Net_Value'].to_f < previous_net_value then
		lose_number = lose_number+1
		previous_net_value = row['Net_Value'].to_f
	else win_number = win_number+1
		previous_net_value = row['Net_Value'].to_f
	end
	end
end
rate = win_number.to_f/(win_number.to_f+lose_number.to_f)
    puts "Number of buyin is: #{buyin_number}" 
    puts "Number of win is: #{win_number}"
    puts "Number of lose is: #{lose_number}"
    puts "Win rate is: #{rate.round(4)*100}%"
    puts ""
    end

#平均最大盈利（MFE）和平均最大衰落（MAE）
def mfe_mae
	arr_MFE = []
	arr_MAE = []
	buyin_price =0.0
	max_price =0.0
	min_price =0.0
	price =0.0

	CSV.foreach("demo.csv", :headers =>true) do |row|
		if row['交易类型'] == 'In' then
			price = row['当前交易价'].to_f 
			if buyin_price == 0 then
				buyin_price = price
				max_price = price
				min_price = price
				else 
				if price > buyin_price and price > max_price then
						max_price = price
				else 
					if price < buyin_price and  price < min_price then
						min_price = price
					end
				end
			end
		else
		arr_MFE << (max_price - buyin_price)/buyin_price
		arr_MAE << (buyin_price- min_price)/buyin_price
		buyin_price =0
		max_price =0
		min_price =0
		end
	end

	avg_MFE = arr_MFE.inject{ |sum, el| sum + el }.to_f / arr_MFE.size
	avg_MAE = arr_MAE.inject{ |sum, el| sum + el }.to_f / arr_MAE.size

	puts "Average MFE is: #{avg_MFE.round(4)*100}%"
	puts "Max favorable excursion is: #{arr_MFE.max.round(4)*100}%"
	puts "Average MAE is: #{avg_MAE.round(4)*100}%"
	puts "Max adverse excursion is: #{arr_MAE.max.round(4)*100}%"
	puts ""

end

#交易活跃度（开仓时间占总时间百分比）
def trade_activity_ratio

start_time = nil
diff = 0

filename = './data.csv'
total_minutes = %x{wc -l #{filename}}.split.first.to_i

CSV.foreach("demo.csv", :headers =>true) do |row| 
	if row['交易类型'] == 'In' then 
		if start_time == nil then 
			start_time = Time.parse(row['时间']).to_i
		end
	else
		end_time = Time.parse(row['时间']).to_i
		diff = diff + (end_time.to_f - start_time.to_f)/60
		start_time = nil
	end
end
	
trade_activity_ratio = diff / total_minutes
puts "Trade activity raito is: #{trade_activity_ratio.round(4)*100}%"
puts ""
	
end
win_rate
mfe_mae
trade_activity_ratio