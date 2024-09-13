# frozen_string_literal: true

require "spec_helper"

RSpec.describe LLM::Clients::Anthropic do
  describe "#chat" do
    let(:llm) { LLM.from_string!("claude-3-5-sonnet-20240620") }
    let(:client) { described_class.new(llm: llm) }
    subject(:response) { client.chat([{role: :user, content: "hello world"}], max_output_tokens: 100) }

    shared_examples "a method that generates a response value" do
      it "returns a response" do |example|
        with_vcr(example) do
          expect(response).to be_a(LLM::Response)
        end
      end

      it "returns a response with content" do |example|
        with_vcr(example) do
          expect(response.content).to be_a(String)
        end
      end

      it "returns a response with a stop reason" do |example|
        with_vcr(example) do
          expect(response.stop_reason).to be(LLM::StopReason::STOP)
        end
      end

      it "returns a response with a raw response" do |example|
        with_vcr(example) do
          expect(response.raw_response).to_not be_nil
        end
      end
    end

    it_behaves_like "a method that generates a response value"
  end
end
