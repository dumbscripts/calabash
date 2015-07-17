

class ADB

	def self.deleteChars(times)
		times.times {`adb shell input keyevent 67`}
		sleep 1
	end

	def self.goBack()
		`adb shell input keyevent 4`
	end
end