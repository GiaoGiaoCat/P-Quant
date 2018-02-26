require 'csv'
require 'time'

start_time = nil


filename = './data.csv'
total_minutes = %x{wc -l #{filename}}.split.first.to_i
diff = nil
CSV.foreach("demo.csv", :headers =>true) do |row| 
	if row['交易类型'] == 'In' then 
		if start_time == nil then 
			start_time = Time.parse(row['时间']).to_i
		end
	else
		end_time = Time.parse(row['时间']).to_i
		diff = (end_time.to_f - start_time.to_f)/60
	end
end
	
trade_activity_ratio = diff / total_minutes
puts diff
puts total_minutes
puts trade_activity_ratio

			
			

