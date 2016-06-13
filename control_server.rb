require "serialport"
 
#params for serial port
port_str = ARGV[0] || "/dev/cu.usbserial-0000114"  #may be different for you
baud_rate = 9600
data_bits = 8
parity = SerialPort::NONE
stop_bits = 1
 
sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
 
#just read forever
puts "Got: "+sp.gets

running = true
while STDIN.gets do
  command = $_.chomp
  sleep 0.2
  sp.write command
  puts "Sent #{command.inspect} Got: "+sp.gets.inspect
end

puts "No more input"
sp.close
