#Author: Mahesh Hadimani
#Date: 12-Mar-2015

require 'calabash-android/operations'
require 'calabash-cucumber/operations'

class Calx

	if ENV['PLATFORM'] == 'android'
		puts "Found android platform - loading calabash-android modules"
		extend Calabash::Android::Operations
	elsif ENV['PLATFORM'] == 'ios'
		puts "Found ios platform - loading calabash-ios modules"
		extend Calabash::Cucumber::Operations
	else
		raise "Unable to load platform specific calabash modules"
	end

	def self.executeQuery(locator, type=nil)
		tries = 5; count = 0
		queryResult = Hash.new

		begin
			queryResult = query("#{locator}")
			if queryResult.nil?
				raise "query returned nil"
			end
		rescue => e
			count += 1
			puts "Exception when querying element - #{e.message}"
			sleep 2

			retry if count < tries
		end

		raise "Couldn't find element - #{locator}" if count == tries

		if type.nil?
			res = queryResult
		elsif !queryResult[0].nil?
			res = queryResult[0]["#{type}"]
		end

		return res
	end

	def self.getText(element)
		res = executeQuery(element, "text")
		if res.nil?
			return executeQuery(element, "textContent").delete("\n").strip
		else
			return res
		end
	end

	def self.getValue(element)
		res = executeQuery(element, "value")
		return res
	end

	def self.scrollToElement(element)
		begin
			wait_poll({:until_exists => element, :timeout => 2}) do 
	    		scrollUp(element)
	    	end
		rescue => e
			scrollDown(element)
			sleep 2
			wait_poll({:until_exists => element, :timeout => 2}) do 
	    		scrollDown(element)
	    	end
		end
	end

	def self.tap(element)
		#scrollToElement(element)
		ele = executeQuery(element)
		if !ele.empty?
			touch(ele)
			puts "Tapped - #{element}"
		else
			raise "Query returned null for the locator -- #{ele}"
		end
		if (Common.isIOS && Common.isSimulator)   ##Just a check to handle other cases
			sleep 1.5
			if isElementPresent(element)
				uia_tap(element)
				puts "Tapped using UIA - #{element}"
			end
		end
	end
	
	def self.setText(element, text)
		if Common.isIOS && Common.isSimulator
			tap(element)
		end
		enter_text("#{element}", "")
		enter_text("#{element}", "#{text}")
		puts "Entered text into field - #{element}"
		#if !Common.isIOS
		#	hide_soft_keyboard 
		#	sleep 0.5
		#end
		dismissKeypad()
	end

	def self.typeKeys(element, text)
		if Common.isIOS && !Common.isSimulator
			tap(element)
		end
		keyboard_enter_char("#{element}", "")
		keyboard_enter_char("#{element}", "#{text}")
		puts "Entered chars into field - #{element}"
		if !Common.isIOS
			hide_soft_keyboard 
			sleep 0.5
		end
	end

	def self.isElementPresent(element)
		found = element_exists(element)
		return found
	end

	def self.assertTextTrue(h)
		assertText(h, true)
	end
	
	def self.assertTextFalse(h)
		assertText(h, false)
	end
	
	def self.assertText(hashData, type=nil)
		str, res = nil

		hashData.each_pair do |key, value|
			str = key
			res = value
		end
		raise "type should be either true or false" if type.nil?

		if type
			if str == res
				puts "Found text -- #{str}"
			else
				raise "FAIL - *** EXPECTED - #{str}, *** ACTUAL - #{res}***"
			end
		else
			if str != res
				puts "Couldn't find text - #{str} on device"
			else
				raise "FAIL - Found text #{str} on device"
			end
		end
	end

	def self.assertTextAll(hashData)
		hashData.each_pair do |key, value|
			data = {key => value}
			assertTextTrue(data)
		end
	end

	def self.verifyTrue(element)
	end

	def self.verifyFalse(element)
	end
	
	def self.isEnabled(element)
		found = false
		result = executeQuery(element, "enabled")
				
		if result
			found = true
		elsif result.nil?
			raise "Query returned null for the locator -- #{element}"
		end

		return found
	end

	def self.waitForElement(*args)
		wait_for_element_exists(args[0], :timeout => 60, :timeout_message => "Timed out waiting for element- #{args}")
	end

	def self.waitShort(*args)
		wait_for_element_exists(args[0], :timeout => 30, :timeout_message => "Timed out waiting for element- #{args}")
	end

	def self.waitForElementNotExists(*args)
		wait_for_elements_do_not_exist(args[0], :timeout => 30, :timeout_message => "Found element - #{args}")
	end

	def self.scrollUp(element=nil)
		if Common.isIOS
			scroll(element, :up)
		else
			#perform_action("scroll_up")
			scroll_up
		end
	end

	def self.scrollDown(element=nil)
		if Common.isIOS
			scroll(element, :down)
		else
			#perform_action("scroll_down")
			scroll_down
		end
	end

	def self.scrollTo(element, row=nil)
		row = 3	if row.nil? 

		if Common.isIOS
			scroll_to_cell({:query => element, :row => row, :section => 0, :scroll_position => :top, :animate => true})
		else
			scroll_to(element)
		end
	end

	def self.swipeLeft(element)
		if Common.isIOS
			swipe(:left, {query:element})
		else
			pan(element, :left)
		end

	end

	def self.swipeRight(element)
		if Common.isIOS
			swipe(:right, {query:element})
		else
			pan(element, :right)
		end
	end

	def self.dismissKeypad
		if !Common.isIOS
			hide_soft_keyboard
			sleep 0.5
		elsif Common.isIpad
			dismiss_ipad_keyboard
			sleep 0.5
		elsif Common.isIOS && !Common.isIpad
			tap("UIButtonLabel text:'Done'")
			sleep 0.5
		end
	end

	def self.getTextFromElements(arr)
		res = []
		arr.each_with_index do |ele, index|
			x = arr[index]["text"]
			if x.nil?
				x = arr[index]["textContent"]
			end
			res.push(x)
		end
		return res
	end

	# date_str can be in any format that Date can parse
	def self.setDate(date_str)
		Common.isIOS ? setDateIOS(date_str) : setDateAndroid(date_str)
	end

	def self.setTime(time_str)
  		Common.isIOS ? setTimeIOS(time_str) : setTimeAndroid(time_str)
	end

	def self.setDateIOS(date_str)
		STDOUT.puts "date_str --> #{date_str}"
  		target_date = Date.parse(date_str)
		current_time = date_time_from_picker()
	    date_time = DateTime.new(target_date.year,
                            target_date.mon,
                            target_date.day,
                            current_time.hour,
                            current_time.min,
                            0,
                            Time.now.sec,
                            current_time.offset)
 	    picker_set_date_time(date_time)
  		sleep 0.5
	end

	def self.setTimeIOS(time_str)
		target_time = Time.parse(time_str)
		current_date = date_time_from_picker()
		current_date = DateTime.new(current_date.year,
	                           current_date.mon,
                               current_date.day,
                               target_time.hour,
                               target_time.min,
                               0,
                               target_time.gmt_offset)
		picker_set_date_time(current_date)
  		sleep 0.5
	end

	##Locators hard coded for now, need a better solution
	def self.setDateAndroid(date_str)
		res = date_str.split("-")
		set_date("android.widget.DatePicker", res[0].to_i, res[1].to_i, res[2].to_i)
	end

	def self.setTimeAndroid(time_str)
		timeHr = "android.widget.NumberPicker index:0"
		timeMin = "android.widget.NumberPicker index:1"
		timeFormat = "android.widget.NumberPicker index:2"
		ampm = "* id:'numberpicker_input' index:2"
		ampmIncrement = "* id:'increment' index:2"
		ampmDecrement = "* id:'decrement' index:2"

		isElementPresent(timeFormat) ? found = true : found = false
		
		if !found
			t = time_str.split(" ")[1].split(":")
			query(timeHr, :setValue => t[0].to_i)
			sleep 0.5
			query(timeMin, :setValue => t[1].to_i)
		else
			timeStr = Time.parse(time_str).strftime("%I:%M %p").to_s
			tArr = timeStr.split(":")
			hr = tArr[0]
			min = tArr[1].split(" ")[0]
			format = tArr[1].split(" ")[1]

			STDOUT.puts "timeStr --> #{timeStr}"
			STDOUT.puts "format --> #{format}"
			STDOUT.puts "ampm --> #{getText(ampm)}"
			
			if hr[0].to_i == 0
				query(timeHr, :setValue => hr[1].to_i)
			else
				query(timeHr, :setValue => hr.to_i)
			end
			sleep 0.5
			query(timeMin, :setValue => min.to_i)
			sleep 0.5
			if !((getText(ampm)) == format)
				tap(ampmDecrement)
			else
				tap(ampmIncrement)
			end
		end

	end

	def self.embed(*args) #Dummy
 		puts "Embed is a Cucumber method and is not available in this console."
 	end

end
