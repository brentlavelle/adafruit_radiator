require 'slack-ruby-bot'

module AdafruitRadiator
  class SlackTeamcityMessage
    attr_reader :status, :job

    def initialize message
      @message = message
      # the regexp below matches team city slackbot message text
      if match = message.text.match(/\|(\w+) \- (.+) \#(\d+|\?+)/)
        @status = match[1].downcase.to_sym
        @job    = match[2].downcase.to_sym
        @valid  = true
      else
        @valid = false
      end
      @valid
    end

    def color
      return nil unless @message.attachments
      @message.attachments.each { |attachment| return attachment.color if attachment.color }
    end

    def valid?
      @valid
    end
  end
end
