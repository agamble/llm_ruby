# frozen_string_literal: true

require "httparty"

class LLM::Clients::Anthropic
  include HTTParty
  base_uri "https://api.anthropic.com"

  def initialize(llm:)
    @llm = llm
  end

  def chat(messages, options = {})
    request = payload(messages, options)

    resp = post_url("/v1/messages", body: request.to_json)

    Response.new(resp).to_normalized_response
  end

  private

  def payload(messages, options = {})
    {
      system: combined_system_messages(messages),
      messages: messages.filter { |m| m[:role].to_sym != :system },
      model: @llm.canonical_name,
      max_tokens: options[:max_output_tokens],
      temperature: options[:temperature],
      top_p: options[:top_p],
      top_k: options[:top_k],
      stream: options[:stream]
    }.compact
  end

  def combined_system_messages(messages)
    messages.filter { |m| m[:role].to_sym == :system }.map { |m| m[:content] }.join('\n\n')
  end

  def post_url(url, body:)
    self.class.post(url, body: body, headers: {
      "anthropic-version" => "2023-06-01",
      "x-api-key" => ENV["ANTHROPIC_API_KEY"],
      "Content-Type" => "application/json"
    })
  end
end
