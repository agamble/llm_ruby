# frozen_string_literal: true

require 'spec_helper'
require 'support/basic_chat_examples'
require 'support/streaming_chat_examples'

RSpec.describe LLM::Clients::OpenAI do
  LLM.all!.select { |model| model.provider == :openai }.each do |model|
    describe '#chat' do
      it_behaves_like 'a model that supports basic chat', llm_canonical_name: model.canonical_name
      it_behaves_like 'a model that supports streaming responses', llm_canonical_name: model.canonical_name
    end
  end
end
