module ImpactRadiusAPI
  class Error < StandardError
    attr_reader :message, :status

    def initialize(message = nil, status = nil)
      @message = message
      @status    = status
    end

    def to_s
      status_string = status.nil? ? "" : " (Status #{status})"
      "#{message}#{status_string}"
    end
  end
end