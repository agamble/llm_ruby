# frozen_string_literal: true

class LLM
  module StopReason
    STOP = :stop
    SAFETY = :safety
    MAX_TOKENS_REACHED = :max_tokens
    STOP_SEQUENCE = :stop_sequence

    OTHER = :other
  end
end
