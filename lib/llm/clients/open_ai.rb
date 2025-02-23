# frozen_string_literal: true

require "httparty"
require "event_stream_parser"

class LLM
  module Clients
    class OpenAI
      include HTTParty
      base_uri "https://api.openai.com/v1"

      def initialize(llm:)
        @llm = llm
      end

      def chat(messages, options = {})
        parameters = {
          model: @llm.canonical_name,
          messages: messages,
          temperature: options[:temperature],
          response_format: options[:response_format],
          max_tokens: options[:max_output_tokens],
          top_p: options[:top_p],
          stop: options[:stop_sequences],
          presence_penalty: options[:presence_penalty],
          frequency_penalty: options[:frequency_penalty],
          tools: options[:tools],
          tool_choice: options[:tool_choice]
        }.compact

        return chat_streaming(parameters, options[:on_message], options[:on_complete]) if options[:stream]

        resp = post_url("/chat/completions", body: parameters.to_json)

        Response.new(resp).to_normalized_response
      end

      private

      def chat_streaming(parameters, on_message, on_complete)
        buffer = +""
        chunks = []
        output_data = {}

        wrapped_on_complete = lambda { |stop_reason|
          output_data[:stop_reason] = stop_reason
          on_complete&.call(stop_reason)
        }

        parameters[:stream] = true

        proc = stream_proc(buffer, chunks, on_message, wrapped_on_complete)

        parameters.delete(:on_message)
        parameters.delete(:on_complete)

        _resp = post_url_streaming("/chat/completions", body: parameters.to_json, &proc)

        LLM::Response.new(
          content: buffer,
          raw_response: chunks,
          stop_reason: output_data[:stop_reason]
        )
      end

      def stream_proc(buffer, chunks, on_message, complete_proc)
        each_json_chunk do |_type, event|
          next if event == "[DONE]"

          chunks << event
          new_content = event.dig("choices", 0, "delta", "content")
          stop_reason = event.dig("choices", 0, "finish_reason")

          buffer << new_content unless new_content.nil?
          on_message&.call(new_content) unless new_content.nil?
          complete_proc&.call(Response.normalize_stop_reason(stop_reason)) unless stop_reason.nil?
        end
      end

      def each_json_chunk
        parser = EventStreamParser::Parser.new

        proc do |chunk, _bytes, env|
          if env && env.status != 200
            raise_error = Faraday::Response::RaiseError.new
            raise_error.on_complete(env.merge(body: try_parse_json(chunk)))
          end

          parser.feed(chunk) do |type, data|
            next if data == "[DONE]"

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
          "Authorization" => "Bearer #{ENV["OPENAI_API_KEY"]}",
          "Content-Type" => "application/json"
        }
      end
    end
  end
end
