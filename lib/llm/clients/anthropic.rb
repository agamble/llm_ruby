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

    return chat_streaming(request, options[:on_message], options[:on_complete]) if options[:stream]

    resp = post_url("/v1/messages", body: request.to_json)

    Response.new(resp).to_normalized_response
  end

  private

  def chat_streaming(request, on_message, on_complete)
    buffer = +""
    chunks = []
    output_data = {}

    wrapped_on_complete = lambda { |stop_reason|
      output_data[:stop_reason] = stop_reason
      on_complete&.call(stop_reason)
    }

    request[:stream] = true

    proc = handle_event_stream(buffer, chunks, on_message_proc: on_message, on_complete_proc: wrapped_on_complete)

    _resp = post_url_streaming("/v1/messages", body: request.to_json, &proc)

    LLM::Response.new(
      content: buffer,
      raw_response: chunks,
      stop_reason: Response.normalize_stop_reason(output_data[:stop_reason])
    )
  end

  def handle_event_stream(buffer, chunks, on_message_proc:, on_complete_proc:)
    each_json_chunk do |type, chunk|
      chunks << chunk
      case type
      when "content_block_delta"
        new_content = chunk.dig("delta", "text")
        buffer << new_content
        on_message_proc.call(new_content)
      when "message_delta"
        finish_reason = chunk.dig("delta", "stop_reason")
        on_complete_proc.call(finish_reason)
      else
        next
      end
    end
  end

  def each_json_chunk
    parser = EventStreamParser::Parser.new

    proc do |chunk|
      # TODO: Add error handling.

      parser.feed(chunk) do |type, data|
        yield(type, JSON.parse(data))
      end
    end
  end

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
    self.class.post(url, body: body, headers: default_headers)
  end

  def post_url_streaming(url, **kwargs, &block)
    self.class.post(url, **kwargs.merge(headers: default_headers, stream_body: true), &block)
  end

  def default_headers
    {
      "anthropic-version" => "2023-06-01",
      "x-api-key" => ENV["ANTHROPIC_API_KEY"],
      "Content-Type" => "application/json"
    }
  end
end
