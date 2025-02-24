require "logger"

class LLM
  class Config
    attr_accessor :logger

    def initialize
      @logger = ::Logger.new($stderr)
      @logger.level = ::Logger::INFO
    end
  end
end
