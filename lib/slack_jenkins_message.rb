require 'slack-ruby-bot'

module AdafruitRadiator
  class SlackJenkinsMessage
    attr_reader :status, :job, :build_id, :color

    def initialize message
      @message = message
      # the regexp below matches Jenkins slackbot message text
      if !message.attachments.nil? && !message.attachments.first.fallback.nil? && match = message.attachments.first.fallback.match(/(\w+) \- \#(\d+|\?+)(.+)?/)
        @job      = match[1].downcase
        @build_id = match[2]
        @build_id = false if @build_id.match /\?+/ #if the build ID isn't a number it isn't a build id

        @color    = message.attachments.first.color
        @valid    = true
        case @color
          when '36a64f'
            @status = :succeeded
          when 'd00000'
            @status = :failed
          else
            @valid = false
        end
      else
        @valid = false
      end
      @valid
    end

    def valid?
      @valid
    end
  end
end
