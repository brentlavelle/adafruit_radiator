require 'slack-ruby-client'

module AdafruitRadiator
  class SlackMonitor
    def initialize token
      Slack.configure do |config|
        config.token = token
      end

      @client = Slack::RealTime::Client.new
    end

    def color
      return nil unless @message.attachments
      @message.attachments.each {
          |attachment| return attachment.color if attachment.color
      }
      return nil
    end

    def when_message &block
      @client.on :message do |data|
        yield data
      end
    end

    def start
      @client.start!
    end
  end
end
