require 'logger'
require_relative '../lib/slack_status'
require_relative '../lib/slack_monitor'
require_relative '../lib/usb_lights'

# params for serial port
light_number    = ARGV[0] || 0 # This is the pin position of this light in the chain
port_str        = ARGV[1] || Dir.glob('/dev/cu.usbserial-*').first
light_bridge    = AdafruitRadiator::LightBridge.new port_str

# params for slack
env_var='SLACK_LIGHT_TOKEN'
token = ENV[env_var] or raise Exception, "You must set env variable #{env_var} to your slack token"

status_color = {
    running:   '1111ff',
    failed:    'ff0505',
    succeeded: '05ff05',
}

# test the light then turn it off
logger = Logger.new STDOUT
logger.info "Test lights"
status_color.each_value do |color|
  light_bridge.set_light light_number, color
  sleep 0.3
end
light_bridge.set_light light_number, '000000'


logger = Logger.new STDOUT
slack_monitor = AdafruitRadiator::SlackMonitor.new token
logger.info "Connected to Slack"

slack_monitor.when_message do |data|
  message = AdafruitRadiator::SlackTeamcityMessage.new data
  next unless message.valid?
  color = status_color[message.status]
  logger.info "Status: #{message.status} color: #{color} job: #{message.job.inspect}"
  light_bridge.set_light light_number, color
end

slack_monitor.start
