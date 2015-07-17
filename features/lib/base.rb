#Author: Mahesh Hadimani
#Date: 03-Mar-2015

##Class to instantitate objects
class Base

	def self.page(className)
    	objs = ObjectSpace.each_object(className)
    	objectsCount = objs.count
    	if objectsCount != 0
    		puts "- - - - - - - - - - - - - - - - - - - - - - - - - - "
	    	puts "Returning an existing instance for class - #{className}"
	    	puts "- - - - - - - - - - - - - - - - - - - - - - - - - - "
	    	return objs.to_a[0]
    	else
	    	puts "- - - - - - - - - - - - - - - - - - - - - - - - - - "
	    	puts "Creating a new instance for class - #{className}"
	    	puts "- - - - - - - - - - - - - - - - - - - - - - - - - - "
	    	return className.new
   		end
	end

end
