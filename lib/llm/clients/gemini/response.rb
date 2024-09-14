# frozen_string_literal: true

class LLM::Clients::Gemini::Response
  def initialize(raw_response)
    @raw_response = raw_response
  end

  def to_normalized_response
    LLM::Response.new(
      content: content,
      raw_response: parsed_response,
      stop_reason: translated_stop_reason
    )
  end

  def self.normalize_stop_reason(stop_reason)
    case stop_reason
    when "STOP"
      LLM::StopReason::STOP
    when "MAX_TOKENS"
      LLM::StopReason::MAX_TOKENS
    when "SAFETY"
      LLM::StopReason::SAFETY
    else
      LLM::StopReason::OTHER
    end
  end

  private

  attr_reader :raw_response

  def content
    parsed_response.dig("candidates", 0, "content", "parts", 0, "text")
  end

  def stop_reason
    parsed_response.dig("candidates", 0, "finishReason")
  end

  def translated_stop_reason
    self.class.normalize_stop_reason(stop_reason)
  end

  def parsed_response
    raw_response.parsed_response
  end
end
