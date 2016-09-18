require 'rspec'
require 'yaml'
require_relative '../lib/slack_status'

describe 'parse TeamCity Slackbot messages' do
  def each_message(pattern)
    yaml_path = File.expand_path('../slack_tc_messages', __FILE__)
    Dir.foreach(yaml_path) do |file_name|
      next unless file_name.match pattern
      yield YAML.load(File.read("#{yaml_path}/#{file_name}"))
    end
  end

  it 'can parse simple running messages' do
    each_message /^start/ do |message|
      stm = AdafruitRadiator::SlackTeamcityMessage.new message
      expect(stm.valid?).to be true
      expect(stm.status).to be == :running
    end
  end
end
