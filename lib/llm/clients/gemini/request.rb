# frozen_string_literal: true

class LLM
  module Clients
    class Gemini
      class Request
        def initialize(messages, options)
          @messages = messages
          @options = options
        end

        def model_for_url
          "models/#{model}"
        end

        def params
          {
            systemInstruction: normalized_prompt,
            contents: normalized_messages
          }
        end

        private

        attr_reader :messages, :options

        def model
          options[:model]
        end

        def normalized_messages
          user_visible_messages
            .map(&method(:message_to_gemini_message))
        end

        def message_to_gemini_message(message)
          {
            role: ROLES_MAP[message[:role]],
            parts: [{ text: message[:content] }]
          }
        end

        def normalized_prompt
          return nil if system_messages.empty?

          system_messages
            .map { |message| message[:content] }
            .join("\n\n")
        end

        def system_messages
          messages.filter { |message| message[:role] == :system }
        end

        def user_visible_messages
          messages.filter { |message| message[:role] != :system }
        end

        ROLES_MAP = {
          assistant: :model,
          user: :user
        }.freeze
      end
    end
  end
end
