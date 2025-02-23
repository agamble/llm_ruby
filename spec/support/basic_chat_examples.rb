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

  context "when the model supports structured outputs" do
    let(:schema) { LLM::Schema.new("test", {"type" => "object", "properties" => {"name" => {"type" => "string"}, "age" => {"type" => "integer"}}, "additionalProperties" => false, "required" => ["name", "age"]}) }
    subject(:response) { client.chat([{role: :user, content: "hello world"}], response_format: schema) }

    it "returns a response with a structured output" do |example|
      next unless llm.supports_structured_outputs?

      with_vcr_for_model(llm, example) do
        expect(response.structured_output).to be_a(Hash)
      end
    end

    it "returns a response with a structured output object" do |example|
      next unless llm.supports_structured_outputs?

      with_vcr_for_model(llm, example) do
        expect(response.structured_output_object.name).to be_a(String)
        expect(response.structured_output_object.age).to be_a(Integer)
      end
    end
  end
end
