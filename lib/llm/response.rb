# frozen_string_literal: true

require "ostruct"

LLM::Response = Struct.new(:content, :raw_response, :stop_reason, :structured_output, keyword_init: true) do
  def structured_output_object
    return nil unless structured_output

    OpenStruct.new(structured_output)
  end
end
