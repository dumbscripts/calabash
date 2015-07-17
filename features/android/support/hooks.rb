

Before do |scenario|
	STDOUT.puts "******************************* #{scenario.source_tag_names[0]} - Start *******************************"
end

After do |scenario|
	STDOUT.puts "******************************* #{scenario.source_tag_names[0]} - End *******************************"
end