require 'pry'
require 'logger'
require 'serialport'
require 'slack-ruby-bot'

#params for serial port
port_str = "/dev/cu.usbserial-00001141"  #may be different for you
baud_rate = 9600
data_bits = 8
parity = SerialPort::NONE
stop_bits = 1

#params for slack
default_channel = 'bot-land'
env_var='SLACK_LIGHT_TOKEN'
prefix = 'light'

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

logger = Logger.new STDOUT
token = ENV[env_var] or raise Exception, "You must set env variable #{env_var} to your slack token"
Slack.configure do |config|
  config.token = token
end

client = Slack::RealTime::Client.new
client.on :hello do
  logger.info 'successfully connected to slack'
  hello_message = sp.gets.inspect
  client.message channel: 'bot-land', text: "slack light bridge started, Arduino status: #{hello_message.inspect}"
end

client.on :message do |data|
  begin
    text = data.text.to_s
    if text.start_with? prefix
      text.gsub!(prefix, '').lstrip!.rstrip!
      user = Slack::Web::Client.new.users_info(user: data.user)
      logger.info "user #{user['user']['real_name']} issued command #{text}"

      sp.write text
      return_string = sp.gets.chomp
      client.message channel: data.channel, text: "I sent command #{text.inspect} and got back #{return_string.inspect}"
    sleep 0.2 # Prevent this bot from going nuts in the chat channel
    end
  rescue Exception => e
    client.message channel: data.channel, text: "something happened #{e.to_s}"
    logger.error e
    logger.error e.backtrace
  end
end

client.start!
