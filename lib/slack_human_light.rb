module AdafruitRadiator
  class SlackHumanLight
    attr_reader :light, :color

    def initialize message
      @message = message
      @valid   = false
      if !message.text.nil? && match = message.text.match(/^light (\d+) (\h{6})/)
        @light   = match[1].to_i
        @color   = match[2].upcase
        @valid   = true
      end
      @valid
    end

    def valid?
      @valid
    end
  end
end
