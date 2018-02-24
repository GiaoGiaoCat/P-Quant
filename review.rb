require 'csv'
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
    puts "number of buyin is:" 
    puts buyin_number
    puts "number of win is:"
    puts win_number
    puts "number of lose is"
    puts lose_number
    puts "win rate is"
    puts rate.round(5)