require 'slack-ruby-bot'

module AdafruitRadiator
  class SlackTeamcityMessage
    attr_reader :status, :job, :build_id

    def initialize message
      @message = message
      # the regexp below matches team city slackbot message text
      if match = message.text.match(/\|(\w+) \- (.+) \#(\d+|\?+)/)
        @status   = match[1].downcase.to_sym
        @job      = match[2].downcase
        @build_id = match[3]
        @build_id = false if @build_id.match /\?+/
        @valid    = true
      else
        @valid = false
      end
      @valid
    end

    def color
      return nil unless @message.attachments
      @message.attachments.each { |attachment| return attachment.color if attachment.color }
      nil
    end

    def valid?
      @valid
    end
  end
end
