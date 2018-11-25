require 'optparse'
require 'socket'

# Default server and port options
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

def pipe(options)
	begin
		socket = TCPSocket.open(options[:ip], options[:port])
	rescue
		puts "[SOCKET ERR] Could not find the server"
	else
		puts "Starting the Client..................."
		puts socket.gets

		if options.has_key? :delay
			sleep(options[:delay])
		end

		STDIN.read.split("\n").each do |a|
   		socket.write(a)
		end
		socket.close
	end
end

pipe(options)
