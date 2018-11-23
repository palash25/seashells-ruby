require 'optparse'
require 'optparse/uri'
require 'socket'

options = {
	:ip => 'seashells.io',
	:port => '1337'
}

OptionParser.new do |opts|
	opts.banner = "Usage: seashells [options] "
	opts.on("-i", "--ip [IP | URI]", "custom IP address or URI; default: seashells.io") do |ip|
		options[:ip] = ip
	end
	opts.on("-p", "--port [Port]", Integer, "port for the IP; default: 1337") do |port|
		options[:port] = port
	end
	opts.on("-d", "--delay [Delay Time]", Integer, "Time delay for piping output in seconds") do |delay|
		options[:delay] = delay
	end
	opts.on("-o", "--output", "output to both console and server or just server") do |output|
		options[:output] = output
	end
end.parse!

puts options

def pipe(options)
	socket = TCPSocket.open(options[:ip], options[:port])

	puts "Starting the Client..................."
	puts socket.gets


	STDIN.read.split("\n").each do |a|
   	socket.write(a)
	end

	socket.close
end

pipe(options)
