# frozen_string_literal: true

require "spec_helper"
require "support/basic_chat_examples"
require "support/streaming_chat_examples"

RSpec.describe LLM::Clients::Gemini do
  model_name = "gemini-1.5-flash"

  describe "#chat" do
    it_behaves_like "a model that supports basic chat", llm_canonical_name: model_name
    it_behaves_like "a model that supports streaming responses", llm_canonical_name: model_name
  end
end
