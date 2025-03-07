# frozen_string_literal: true

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "llm" => "LLM",
  "open_ai" => "OpenAI"
)
loader.ignore("#{__dir__}/llm_ruby.rb")
loader.setup

class LLM
  def initialize(model)
    @canonical_name = model[:canonical_name]
    @display_name = model[:display_name]
    @provider = model[:provider]
    @client_class = model[:client_class]
    @default_params = model[:additional_default_required_parameters] || {}
    @supports_structured_outputs = model[:supports_structured_outputs] || false
  end

  def client
    client_class.new(llm: self)
  end

  attr_reader :canonical_name,
    :display_name,
    :provider,
    :default_params

  def supports_structured_outputs?
    @supports_structured_outputs
  end

  def self.config
    @config ||= LLM::Config.new
  end

  private

  attr_reader :client_class

  class << self
    def all!
      known_models
    end

    def from_string!(model_string)
      model = known_models.find { |model| model.canonical_name == model_string }

      raise ArgumentError, "Unknown model: #{model_string}" unless model

      model
    end

    private

    def known_models
      @known_models ||= LLM::Info::KNOWN_MODELS.map { |model| new(model) }
    end
  end
end
