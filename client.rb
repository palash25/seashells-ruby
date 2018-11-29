require 'optparse'
require 'socket'

# Default server and port options
options = {
	:ip => 'seashells.io',
	:port => '1337'
}

OptionParser.new do |opts|
	opts.banner = "Usage: seashells [options]"
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

def pipe(options={})
	begin
		socket = TCPSocket.open(options[:ip], options[:port])
	rescue Errno::ETIMEDOUT
		return "Connection timed out"
	rescue Errno::ECONNREFUSED
		return "Connection refused"
	rescue SocketError
		return "Socket Error"
	else
		puts "Starting the Client...................\n"
		seashells_url =  socket.gets

		if options.has_key? :delay
			sleep(options[:delay])
		end

		console_input = STDIN.read.split("\n")
		console_input.each do |a|
   			socket.write(a)
		end

		if options.has_key? :output
			puts console_input
		end
	ensure
		if defined? seashells_url
			puts "Piped output is available at url below", seashells_url
		end
		socket.close
	end
end

pipe(options)
