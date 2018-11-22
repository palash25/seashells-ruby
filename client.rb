require 'socket'

socket = TCPSocket.open("seashells.io", 1337)

puts "Starting the Client..................."
puts socket.gets


STDIN.read.split("\n").each do |a|
   socket.write(a)
end


socket.close
