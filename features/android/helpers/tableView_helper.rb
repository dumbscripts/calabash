require_relative '../../lib/calx.rb'


class TableViewHelper
	@@locTableView = "CheckedTextView"
	@@tableScrollView = "UITableView"
	
	def self.getAllItems
		endOfList = false; arr = []; tries = 0

		until endOfList
			data = Calx.executeQuery(@@locTableView)
			res = Calx.getTextFromElements(data)

			res.each do |str|
				if !((str.include?"Done") || (arr.include?str))
					arr.push(str)
				end
			end
			Calx.scrollDown
			data = Calx.executeQuery(@@locTableView)
			res = Calx.getTextFromElements(data)

			sleep 1

			if arr.last == res.last
				tries += 1
			end
			endOfList = true if tries == 2
		end

		return arr
	end


	def self.scrollDownTableView
		Calx.scrollTo("UITableView")
	end

	def self.scrollUpTableView
		Calx.scrollTo("UITableView", 0.3)
	end

	def self.scrollToItem(item)
		count = 0
		query = "* text:'#{item}'"

		if Calx.executeQuery(@@locTableView).length > 2
			2.times do
				Calx.scrollUp
			end
			5.times do
				if Calx.isElementPresent(query)
					break
				else
					Calx.scrollDown
					count = count + 1
				end
			end
			raise "Coudln't find element #{item}" if count == 5
		end
	end

end