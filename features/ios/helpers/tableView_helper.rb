require File.join(File.dirname(__FILE__), '../../lib/calx.rb')

class TableViewHelper
	@@locTableView = "UILabel"
	@@btnDone = "UIButtonLabel text:'Done'"
	@@tableScrollView = "UITableView"
	

	def self.getAllItems
		arr = []; endOfList = false; rowCount = 1;
		
		## Bring the table picker to index 1 position and then scroll through it
		begin
			Calx.scrollTo(@@tableScrollView, rowCount)
			sleep 1
			Calx.scrollTo(@@tableScrollView, rowCount)
			sleep 1
			Calx.scrollTo(@@tableScrollView, rowCount)
			sleep 1
		rescue => e
		end

		res = Calx.executeQuery(@@locTableView)
		arrText = Calx.getTextFromElements(res)
			
		until endOfList do
			arrText.each do |str|
				if !((str == "Done") || (arr.include?str))
					#STDOUT.puts " **** Skipping as the elements is already in the array - #{str} ****"
				#else
					arr.push(str)
				end
			end

			#STDOUT.puts "arr --> #{arr}"
			rowCount < 2.5 ? (rowCount = rowCount+1.5) : (rowCount = rowCount+3)
			begin
				Calx.scrollTo(@@tableScrollView, rowCount)
				#STDOUT.puts "rowCount -- #{rowCount}"
				sleep 1
			
				a = Calx.executeQuery(@@locTableView)
				arrText = Calx.getTextFromElements(a)
			rescue => e
				break if e.message.include?"unable to scroll"
				endOfList = true
			end
		end
		return arr
	end


	def self.scrollDownTableView
		Calx.scrollTo(@@tableScrollView)
	end

	def self.scrollUpTableView
		Calx.scrollTo(@@tableScrollView, 0.3)
	end

	def self.scrollToItem(item)
		endOfList = false; rowCount = 1;
		
		res = Calx.executeQuery(@@locTableView)
		arrText = Calx.getTextFromElements(res)
		STDOUT.puts "arrText before scroll --> #{arrText}"

		if arrText.include?item
			puts "Found item -- #{item}"
			endOfList = true
		else	
			begin
				## Bring the table picker to index 1 position and then scroll through it
				Calx.scrollTo(@@tableScrollView, rowCount)
				sleep 1
				Calx.scrollTo(@@tableScrollView, rowCount)
				sleep 1
				Calx.scrollTo(@@tableScrollView, rowCount)
				sleep 1
			rescue => e
			end
		end
			
		until endOfList do
			arrText.each do |str|
				if arrText.include?item
					puts "Found item -- #{item}"
					endOfList = true
					break
				else
					rowCount < 2.5 ? (rowCount = rowCount+1.5) : (rowCount = rowCount+3)
					begin
						Calx.scrollTo(@@tableScrollView, rowCount)
						#STDOUT.puts "rowCount -- #{rowCount}"
						sleep 1
					rescue => e
							raise "Reached end of list, couldn't find item -- #{item}" if e.message.include?"unable to scroll"
					end
				end

			end
		end
	end

end ##class ends