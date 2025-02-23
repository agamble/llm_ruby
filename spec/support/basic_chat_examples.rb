# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "a model that supports basic chat" do |llm_canonical_name:|
  let(:llm) { LLM.from_string!(llm_canonical_name) }
  let(:client) { described_class.new(llm: llm) }
  subject(:response) { client.chat([{role: :user, content: "hello world"}]) }

  it "returns a response" do |example|
    with_vcr_for_model(llm, example) do
      expect(response).to be_a(LLM::Response)
    end
  end

  it "returns a response with content" do |example|
    with_vcr_for_model(llm, example) do
      expect(response.content).to be_a(String)
    end
  end

  it "returns a response with a stop reason" do |example|
    with_vcr_for_model(llm, example) do
      expect(response.stop_reason).to be(LLM::StopReason::STOP)
    end
  end

  it "returns a response with a raw response" do |example|
    with_vcr_for_model(llm, example) do
      expect(response.raw_response).to_not be_nil
    end
  end
end
