require 'logger'
require_relative '../lib/slack_status'
require_relative '../lib/slack_human_light'
require_relative '../lib/slack_monitor'
require_relative '../lib/usb_lights'

# params for serial port
test_lights  = [0, 1, 2]
port_str     = ARGV[0] || Dir.glob('/dev/cu.usbserial-*').first
light_bridge = AdafruitRadiator::LightBridge.new port_str

# params for slack
env_var      ='SLACK_LIGHT_TOKEN'
token        = ENV[env_var] or raise Exception, "You must set env variable #{env_var} to your slack token"

configuration = [
    [/thing build/,  [0, 1]],
    [/thing deploy/, [0, 2]],
    [/thing test/,   [0, 3]],
]

status_color = {
    running:   '1111ff',
    failed:    'ff0505',
    succeeded: '05ff05',
}

# test the light then turn it off
logger       = Logger.new STDOUT
logger.info "Test lights"
status_color.each_value do |color|
  test_lights.each do |light|
    light_bridge.set_light light, color
  end
  sleep 0.3
end
test_lights.each do |light|
  light_bridge.set_light light, '000000'
end


logger        = Logger.new STDOUT
slack_monitor = AdafruitRadiator::SlackMonitor.new token
logger.info "Connected to Slack"

slack_monitor.when_message do |data|
  message = AdafruitRadiator::SlackTeamcityMessage.new data
  if message.valid?
    color = status_color[message.status]
    job   = message.job
    logger.info "Status: #{message.status} color: #{color} job: #{job.inspect}"
    configuration.each do |config|
      next unless job.match config[0]
      config[1].each do |light_number|
        logger.info "light #{light_number} to #{color}"
        light_bridge.set_light light_number, color
      end
    end
  end

  message = AdafruitRadiator::SlackHumanLight.new data
  if message.valid?
    light_number = message.light
    color = message.color
    logger.info "light #{light_number} to #{color}"
    light_bridge.set_light light_number, color
  end
end

slack_monitor.start
