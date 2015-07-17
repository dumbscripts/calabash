#Author: Mahesh Hadimani
#Date: 31-Mar-2015

## Class used to instantiate element locators
class ObjectBase
	attr_accessor :ele
	
	def initialize(ele)
		@ele = ele
	end

	def getText
		Calx.getText(ele)
	end

	def getValue
		Calx.getValue(ele)
	end

	def tap
		Calx.tap(ele)
	end
	
	def isEnabled
		Calx.isEnabled(ele)
	end

	def isElementPresent
		Calx.isElementPresent(ele)
	end

	def waitTillAppears
		Calx.waitForElement(ele)
	end

	def waitShort
		Calx.waitShort(ele)
	end

	def getElements
		Calx.executeQuery(ele)
	end

	def scrollUp()
		Calx.scrollUp(ele)
	end

	def scrollDown()
		Calx.scrollDown(ele)
	end

	def getTextFromElements()
		res = getElements
		arr = Calx.getTextFromElements(res)
		return arr
	end

	def swipeLeft()
		Calx.swipeLeft(ele)
	end

	def swipeRight()
		Calx.swipeRight(ele)
	end

end

class CalLabel < ObjectBase
	
	def initialize(ele)
		super(ele)
	end

end	

class CalButton < ObjectBase

	def initialize(ele)
		super(ele)
	end

end

class CalText < ObjectBase

	def initialize(ele)
		super(ele)
	end

	def set(text)
		Calx.setText(ele, text)
	end

	def typeKeys(text)
		Calx.typeKeys(ele, text)
	end
end

class CalTab < ObjectBase

	def initialize(ele)
		super(ele)
	end

end

class CalCalender < ObjectBase

	def initialize(ele)
		super(ele)
	end

	def setDate(date)
		Calx.setDate(date)
	end

	def setTime(time)
		Calx.setTime(time)
	end

end

class CalCheckBox < ObjectBase

	def initialize(ele)
		super(ele)
	end

	def isSelected()
		Calx.isEnabled(ele)
	end

end
