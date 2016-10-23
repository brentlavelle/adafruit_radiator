require 'serialport'

module AdafruitRadiator
  class LightBridge
    def initialize port_name, baud_rate=9600, data_bits=8, parity=SerialPort::NONE, stop_bits=1
      @disabled = port_name.nil?
      return if @disabled
      @sp = SerialPort.new(port_name, baud_rate, data_bits, stop_bits, parity)
      sleep 0.1
      hello_message = @sp.gets
      puts "Unexpected hello message from light device: #{hello_message.inspect}" unless hello_message.match(/^Radiator started/)
    rescue Exception => e
      raise Exception, "Could not start LightBridge: #{e}"
    end

    def set_light number, color
      raise ArgumentError, 'Light number must be between 0 and 255' unless (number >= 0 and number <= 255)
      raise ArgumentError, "Invalid color #{color}" unless color.match /^\h{6}$/
      hex_number = '%02X' % number
      message = hex_number+color.upcase
      if @disabled
        puts "Lightbridge disabled: setting #{number} to #{color}"
        return
      end
      @sp.write message+"\n"

      reply = @sp.gets.chomp
      unless reply == "ACK #{message}"
        puts "Reply problem #{reply.inspect} not /^ACK #{message}/"
        reply = @sp.gets.chomp
        puts "Second attempt reply problem #{reply.inspect} not /^ACK #{message}/" unless reply == "ACK #{message}"
      end
    end
  end
end
