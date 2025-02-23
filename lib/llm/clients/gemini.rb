# frozen_string_literal: true

require "httparty"
require "event_stream_parser"

class LLM
  module Clients
    class Gemini
      include HTTParty
      base_uri "https://generativelanguage.googleapis.com"

      def initialize(llm:)
        @llm = llm
      end

      def chat(messages, options = {})
        req = Request.new(messages, options)

        return chat_streaming(req, options[:on_message], options[:on_complete]) if options[:stream]

        resp = post_url(
          "/v1beta/models/#{llm.canonical_name}:generateContent",
          body: req.params.to_json
        )

        Response.new(resp).to_normalized_response
      end

      private

      attr_reader :llm

      def chat_streaming(request, on_message, on_complete)
        buffer = +""
        chunks = []
        output_data = {}

        wrapped_on_complete = lambda { |stop_reason|
          output_data[:stop_reason] = stop_reason
          on_complete&.call(stop_reason)
        }

        proc = handle_event_stream(buffer, chunks, on_message_proc: on_message, on_complete_proc: wrapped_on_complete)

        _resp = post_url_streaming(
          "/v1beta/models/#{llm.canonical_name}:streamGenerateContent?alt=sse",
          body: request.params.to_json,
          &proc
        )

        LLM::Response.new(
          content: buffer,
          raw_response: chunks,
          stop_reason: Response.normalize_stop_reason(output_data[:stop_reason])
        )
      end

      def handle_event_stream(buffer, chunks, on_message_proc:, on_complete_proc:)
        each_json_chunk do |_type, chunk|
          chunks << chunk

          new_content = chunk.dig("candidates", 0, "content", "parts", 0, "text")

          unless new_content.nil?
            on_message_proc&.call(new_content)
            buffer << new_content
          end

          stop_reason = chunk.dig("candidates", 0, "finishReason")
          on_complete_proc&.call(stop_reason) unless stop_reason.nil?
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

      def post_url(url, **kwargs)
        self.class.post(url, **kwargs.merge(headers: default_headers))
      end

      def post_url_streaming(url, **kwargs, &block)
        self.class.post(url, **kwargs.merge(headers: default_headers, stream_body: true), &block)
      end

      def default_headers
        {
          "x-goog-api-key" => ENV["GEMINI_API_KEY"],
          "Content-Type" => "application/json"
        }
      end
    end
  end
end
