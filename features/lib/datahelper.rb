#Author: Mahesh Hadimani
#Date: 24-Mar-2015

require 'yaml'
require 'singleton'

#Helper class to load yaml data
class DataHelper
	include Singleton

	@@TESTDATA = nil

	TESTDATA_FILE = File.join(File.dirname(__FILE__), '../res/testdata.yaml')

	def initialize
		begin
			@@TESTDATA = YAML.load_file(TESTDATA_FILE)
		rescue => e
			raise "Error while loading resource file - #{e.message}"
		end
	end

end
