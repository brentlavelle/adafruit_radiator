require 'serialport'

module AdafruitRadiator
  class LightBridge
    def initialize port_name, baud_rate=9600, data_bits=8, parity=SerialPort::NONE, stop_bits=1
      @sp = SerialPort.new(port_name, baud_rate, data_bits, stop_bits, parity)
      hello_message = @sp.gets.inspect
      puts "Got hello message: #{hello_message}"
    end

    def set_light number, color
      raise ArgumentError, 'Light number must be between 0 and 255' unless (number >= 0 and number <= 255)
      raise ArgumentError, "Invalid color #{color}" unless color.match /^\h{6}$/
      hex_number = '%02X' % number
      @sp.write hex_number+color.upcase+"\n"

      reply = @sp.gets.chomp
      puts "Reply was #{reply}"
    end
  end
end
