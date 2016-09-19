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

  it 'can parse running messages' do
    each_message /^start/ do |message|
      stm = AdafruitRadiator::SlackTeamcityMessage.new message
      expect(stm.valid?).to be true
      expect(stm.status).to be == :running
    end
  end

  it 'can parse succeeded messages' do
    each_message /^succeeded/ do |message|
      stm = AdafruitRadiator::SlackTeamcityMessage.new message
      expect(stm.valid?).to be true
      expect(stm.status).to be == :succeeded
      expect(stm.color).to be == '36a64f'
    end
  end

  it 'can parse failed messages' do
    each_message /^failed/ do |message|
      stm = AdafruitRadiator::SlackTeamcityMessage.new message
      expect(stm.valid?).to be true
      expect(stm.status).to be == :failed
      expect(stm.color).to be == 'd00000'
    end
  end

  it 'can detect unrelated messages' do
    each_message /^unrelated/ do |message|
      stm = AdafruitRadiator::SlackTeamcityMessage.new message
      expect(stm.valid?).to be false
    end
  end
end
