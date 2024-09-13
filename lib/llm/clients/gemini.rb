# frozen_string_literal: true

require "httparty"
require "event_stream_parser"

class LLM::Clients::Gemini
  include HTTParty
  base_uri "https://generativelanguage.googleapis.com"

  def initialize(llm:)
    @llm = llm
  end

  def chat(messages, options = {})
    req = Request.new(messages, options)

    resp = post_url(
      "/v1beta/models/#{llm.canonical_name}:generateContent",
      body: req.params.to_json
    )

    Response.new(resp).to_normalized_response
  end

  private

  attr_reader :llm

  def post_url(url, **kwargs)
    self.class.post(url, **kwargs.merge(headers: default_headers))
  end

  def default_headers
    {
      "x-goog-api-key" => ENV["GEMINI_API_KEY"],
      "Content-Type" => "application/json"
    }
  end
end
