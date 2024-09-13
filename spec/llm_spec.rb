# frozen_string_literal: true

require "spec_helper"

RSpec.describe LLM do
  describe ".from_string!" do
    LLM::Info::KNOWN_MODELS.each do |info|
      it "returns an LLM instance for #{info[:canonical_name]}" do
        expect(described_class.from_string!(info[:canonical_name])).to be_a(described_class)
      end
    end

    it "raises an exception for an unknown model" do
      expect { described_class.from_string!("unknown-model") }.to raise_error(ArgumentError)
    end
  end

  describe ".all!" do
    it "returns all known models" do
      expect(described_class.all!).to all(be_a(described_class))
    end
  end

  describe "#client" do
    LLM.all!.each do |llm|
      it "returns a client for #{llm.canonical_name}" do
        expect(llm.client).to be_a(LLM::Clients::OpenAI)
      end
    end
  end
end
