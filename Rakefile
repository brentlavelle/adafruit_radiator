task :default => [:slack_bridge]

task :slack_bridge do
  sh "bundle exec ruby slack_light_bridge.rb /dev/cu.usbserial-*"
end
