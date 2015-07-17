#Author: Mahesh Hadimani
#Date: 15-Mar-2015

class Common

	if ENV['PLATFORM'] == 'android'
		extend Calabash::Android::Operations
	elsif ENV['PLATFORM'] == 'ios'
		extend Calabash::Cucumber::Operations
	else
		raise "Unable to load platform specific calabash modules"
	end

	def self.isIOS
		res = ENV["PLATFORM"]
		(res == "ios") ? true : false
	end

	def self.isSimulator
		res = ENV["DEVICE_TARGET"]
		if (res.include?"imulator") || (res.nil?)
			return true
		else
			return false
		end
	end

	def self.isIpad
		res = ENV["DEVICE_TARGET"]
		(res.include?"iPad") ? true : false
	end

	def self.genRandom(times)
		i = times.to_i
		o = [('a'..'z'), ('A'..'Z'), (0..9)].map {|i| i.to_a}.flatten
		str = (0...i).map {o[rand(o.length)]}.join
		return str
	end

	def self.genRandomNumber(times)
		i = times.to_i
		o = [(0..9)].map {|i| i.to_a}.flatten
		str = (0...i).map {o[rand(o.length)]}.join
		return str
	end	
end