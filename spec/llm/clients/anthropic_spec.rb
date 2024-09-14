# frozen_string_literal: true

require "spec_helper"
require "support/basic_chat_examples"
require "support/streaming_chat_examples"

RSpec.describe LLM::Clients::Anthropic do
  model_name = "claude-3-haiku-20240307"

  describe "#chat" do
    it_behaves_like "a model that supports basic chat", llm_canonical_name: model_name
    it_behaves_like "a model that supports streaming responses", llm_canonical_name: model_name
  end
end
