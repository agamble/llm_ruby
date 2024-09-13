# frozen_string_literal: true

LLM::Response = Struct.new(:content, :raw_response, :stop_reason, keyword_init: true)
