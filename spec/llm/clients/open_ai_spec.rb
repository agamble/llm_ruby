# frozen_string_literal: true

require "spec_helper"

RSpec.describe LLM::Clients::OpenAI do
  describe "#chat" do
    let(:llm) { LLM.from_string!("gpt-4o-mini") }
    let(:client) { described_class.new(llm: llm) }
    subject(:response) { client.chat([{role: :user, content: "hello world"}]) }

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

    context "when streaming the response" do
      subject(:response) do
        client.chat(
          [{role: :user, content: "hello world"}],
          stream: true,
          on_message:,
          on_complete:
        )
      end

      let(:on_message) { ->(message) {} }
      let(:on_complete) { ->(stop_reason) {} }

      it_behaves_like "a method that generates a response value"

      it "calls the on_message callback" do |example|
        with_vcr(example) do
          expect(on_message).to receive(:call).at_least(:once).with(String)
          response
        end
      end

      it "calls the on_complete callback" do |example|
        with_vcr(example) do
          expect(on_complete).to receive(:call).once.with(LLM::StopReason::STOP)
          response
        end
      end

      context "when no on_message callback is provided" do
        let(:on_message) { nil }

        it_behaves_like "a method that generates a response value"

        it "does not raise an error" do |example|
          with_vcr(example) do
            expect { response }.to_not raise_error
          end
        end
      end

      context "when no on_complete callback is provided" do
        let(:on_complete) { nil }

        it_behaves_like "a method that generates a response value"

        it "does not raise an error" do |example|
          with_vcr(example) do
            expect { response }.to_not raise_error
          end
        end
      end
    end
  end
end
