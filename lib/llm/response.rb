# frozen_string_literal: true

LLM::Response = Struct.new(:content, :raw_response, :stop_reason, :structured_output, keyword_init: true)
