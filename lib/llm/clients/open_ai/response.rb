# frozen_string_literal: true

class LLM
  module Clients
    class OpenAI
      class Response
        def initialize(raw_response)
          @raw_response = raw_response
        end

        def to_normalized_response
          LLM::Response.new(
            content: content,
            raw_response: parsed_response,
            stop_reason: normalize_stop_reason,
            structured_output: structured_output
          )
        end

        def self.normalize_stop_reason(stop_reason)
          case stop_reason
          when "stop"
            LLM::StopReason::STOP
          when "safety"
            LLM::StopReason::SAFETY
          when "max_tokens"
            LLM::StopReason::MAX_TOKENS_REACHED
          else
            LLM::StopReason::OTHER
          end
        end

        private

        def content
          parsed_response.dig("choices", 0, "message", "content")
        end

        def normalize_stop_reason
          self.class.normalize_stop_reason(parsed_response.dig("choices", 0, "finish_reason"))
        end

        def parsed_response
          @raw_response.parsed_response
        end

        def structured_output
          JSON.parse(parsed_response.dig("choices", 0, "message", "content"))
        rescue JSON::ParserError
          nil
        end
      end
    end
  end
end
