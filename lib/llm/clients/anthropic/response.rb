# frozen_string_literal: true

class LLM
  module Clients
    class Anthropic
      class Response
        def initialize(raw_response)
          @raw_response = raw_response
        end

        def to_normalized_response
          LLM::Response.new(
            content: content,
            raw_response: parsed_response,
            stop_reason: normalize_stop_reason
          )
        end

        def self.normalize_stop_reason(stop_reason)
          case stop_reason
          when 'end_turn'
            LLM::StopReason::STOP
          when 'stop_sequence'
            LLM::StopReason::STOP_SEQUENCE
          when 'max_tokens'
            LLM::StopReason::MAX_TOKENS_REACHED
          else
            LLM::StopReason::OTHER
          end
        end

        private

        def content
          parsed_response.dig('content', 0, 'text')
        end

        def normalize_stop_reason
          self.class.normalize_stop_reason(parsed_response['stop_reason'])
        end

        def parsed_response
          @raw_response.parsed_response
        end
      end
    end
  end
end
