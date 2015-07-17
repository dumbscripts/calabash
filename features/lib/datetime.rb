#Author: Mahesh Hadimani
#Date: 21-April-2015


require 'calabash-android/operations'
require 'calabash-cucumber/operations'

class DateTime

	if ENV['PLATFORM'] == 'android'
		puts "Found android platform - loading calabash-android modules"
		extend Calabash::Android::Operations
	elsif ENV['PLATFORM'] == 'ios'
		puts "Found ios platform - loading calabash-ios modules"
		extend Calabash::Cucumber::Operations
	else
		raise "Unable to load platform specific calabash modules"
	end

	@@date, @@time = nil
	@@androidEle = "* id:'numberpicker_input'"

	def self.getDateIOS
		@@date = date_time_from_picker
		return @@date
	end

	def self.getTimeIOS
		@@time = date_time_from_picker
		@@time = Time.parse(@@time.to_s)  ##Conver DateTime object to Time object
		return @@time		
	end

	def self.getDateAndroid
		res = Calx.executeQuery(@@androidEle)
		dateArr = Calx.getTextFromElements(res)
		if dateArr.empty?
			sleep 1
			res = Calx.executeQuery(@@androidEle)
			dateArr = Calx.getTextFromElements(res)
		end	
		formattedString = "#{dateArr[0]}-#{dateArr[1]}-#{dateArr[2]}}"
		STDOUT.puts "formattedString --> #{formattedString}"
		@@date = Date.parse(formattedString)
		return @@date
	end

	def self.getTimeAndroid
		res = Calx.executeQuery(@@androidEle)
		timeArr = Calx.getTextFromElements(res)
		formattedString = "#{timeArr[0]}:#{timeArr[1]} #{timeArr[2]}}"
		@@time = Time.parse(formattedString)
		return @@time
	end

end
