# frozen_string_literal: true

require "spec_helper"
require "support/basic_chat_examples"

RSpec.shared_examples "a model that supports streaming responses" do |llm_canonical_name:|
  let(:llm) { LLM.from_string!(llm_canonical_name) }
  let(:client) { described_class.new(llm: llm) }
  subject(:response) do
    client.chat(
      [{role: :user, content: "hello world"}],
      stream: true,
      max_output_tokens: 100,
      on_message: on_message,
      on_complete: on_complete
    )
  end

  let(:on_message) { ->(message) {} }
  let(:on_complete) { ->(stop_reason) {} }

  it_behaves_like "a model that supports basic chat", llm_canonical_name: llm_canonical_name

  it "returns a response with a content that includes all messages" do |example|
    with_vcr_for_model(llm, example) do
      expect(response.content).to be_a(String)
    end
  end

  context "when the on_message callback is not provided" do
    let(:on_message) { nil }

    it_behaves_like "a model that supports basic chat", llm_canonical_name: llm_canonical_name
  end

  context "when the on_complete callback is not provided" do
    let(:on_complete) { nil }

    it_behaves_like "a model that supports basic chat", llm_canonical_name: llm_canonical_name
  end
end
