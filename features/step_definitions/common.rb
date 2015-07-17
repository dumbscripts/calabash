#Common step defns for both the platforms

Then(/^I close picker$/) do
	iPhoneEle = "* text:'Done'"
	iPadEle = "* id:'PopoverDismissRegion'"
	androidEle = "* id:'button1'"
	androidDatePicker = "android.widget.DatePicker"
	androidTimePicer = ""

	if Calx.isElementPresent(iPhoneEle)
		begin
			Calx.tap(iPhoneEle)
		rescue => e
		end
	end
	if Common.isIOS && Common.isIpad
		begin
			Calx.tap(iPadEle)
		rescue => e
			STDOUT.puts "Error while dismissing picker - #{e.message}"
		end
	end
	if Calx.isElementPresent(androidEle)
		begin
			Calx.tap(androidEle)
			sleep 1
		rescue => e
		end
	end
end

Then(/^I change the time to "([^"]*)"$/) do |time_str|
	@page.calTimePicker.setTime(time_str)
	@time = time_str
	step 'I close picker'
end

Then(/^I change the date to "([^"]*)"$/) do |date_str|
	@page.calDatePicker.setDate(date_str)
	@date = date_str
	step 'I close picker'
end

Then(/^I set the date to (future|past) date from the current date$/) do |arg|
	
	if Common.isIOS
		@currentDate = DateTime.getDateIOS if @currentDate.nil?
	else
		@currentDate = DateTime.getDateAndroid if @currentDate.nil?
	end

	if arg == "future"
		date = @currentDate >> 1
		puts "current Date -> #{@currentDate}, future Date -> #{date}"
	else
		date = @currentDate << 1
		puts "current Date -> #{@currentDate}, past Date -> #{date}"
	end
	date_str = date.to_s	
	step %Q[I change the date to "#{date_str}"]
end

Then(/^I set the time to (future|past) time from the current time$/) do |arg|	
	if Common.isIOS
		@currentTime = DateTime.getTimeIOS if @currentTime.nil?
	else
		@currentTime = DateTime.getTimeAndroid if @currentTime.nil?
	end

	if arg == "future"
		time = @currentTime + (60 * 60)
		puts "current Time -> #{@currentTime}, future Time -> #{time}"
	else
		time = @currentTime - (60 * 60)
		puts "current Time -> #{@currentTime}, past Time -> #{time}"
	end
	step %Q[I change the time to "#{time.to_s}"]
end

Then(/^I set the (time|date) to (current|present) (time|date)$/) do |arg1, arg2, arg3|
	if arg1 == "time"
		if Common.isIOS
			@currentTime = DateTime.getTimeIOS if @currentTime.nil?
		else
			@currentTime = DateTime.getTimeAndroid if @currentTime.nil?
		end
	else
		if Common.isIOS
			@currentDate = DateTime.getDateIOS if @currentDate.nil?
		else
			@currentDate = DateTime.getDateAndroid if @currentDate.nil?
		end
	end

	if arg1 == "time"
		time_str = @currentTime.to_s
		puts "current Time -> #{@currentTime}"
		step %Q[I change the time to "#{time_str}"]
	else
		date_str = @currentDate.to_s
		puts "current Date -> #{@currentDate}"
		step %Q[I change the date to "#{date_str}"]
	end
end
