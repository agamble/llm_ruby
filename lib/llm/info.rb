# frozen_string_literal: true

class LLM
  module Info
    KNOWN_MODELS = [
      # Semantics of fields:
      # - canonical_name (required): A string that uniquely identifies the model.
      #   We use this string as the public identifier when users choose this model via the API.
      # - display_name (required): A string that is displayed to the user when choosing this model via the UI.
      # - client_class (required): The client class to be used for this model.

      # GPT-3.5 Turbo Models
      {
        canonical_name: "gpt-3.5-turbo",
        display_name: "GPT-3.5 Turbo",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "gpt-3.5-turbo-0125",
        display_name: "GPT-3.5 Turbo 0125",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "gpt-3.5-turbo-16k",
        display_name: "GPT-3.5 Turbo 16K",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "gpt-3.5-turbo-1106",
        display_name: "GPT-3.5 Turbo 1106",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },

      # GPT-4 Models
      {
        canonical_name: "gpt-4",
        display_name: "GPT-4",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "gpt-4-1106-preview",
        display_name: "GPT-4 Turbo 1106",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "gpt-4-turbo-2024-04-09",
        display_name: "GPT-4 Turbo 2024-04-09",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "gpt-4-0125-preview",
        display_name: "GPT-4 Turbo 0125",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "gpt-4-turbo-preview",
        display_name: "GPT-4 Turbo",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "gpt-4-0613",
        display_name: "GPT-4 0613",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "gpt-4o",
        display_name: "GPT-4o",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "gpt-4o-mini",
        display_name: "GPT-4o Mini",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "gpt-4o-mini-2024-07-18",
        display_name: "GPT-4o Mini 2024-07-18",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "gpt-4o-2024-05-13",
        display_name: "GPT-4o 2024-05-13",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "gpt-4o-2024-08-06",
        display_name: "GPT-4o 2024-08-06",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "gpt-4o-2024-11-20",
        display_name: "GPT-4o 2024-11-20",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "chatgpt-4o-latest",
        display_name: "ChatGPT 4o Latest",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "o1",
        display_name: "o1",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "o1-2024-12-17",
        display_name: "o1 2024-12-17",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "o1-preview",
        display_name: "o1 Preview",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "o1-preview-2024-09-12",
        display_name: "o1 Preview 2024-09-12",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "o1-mini",
        display_name: "o1 Mini",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "o1-mini-2024-09-12",
        display_name: "o1 Mini 2024-09-12",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "o3-mini",
        display_name: "o3 Mini",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },
      {
        canonical_name: "o3-mini-2025-01-31",
        display_name: "o3 Mini 2025-01-31",
        provider: :openai,
        client_class: LLM::Clients::OpenAI
      },

      # Anthropic Models
      {
        canonical_name: "claude-3-5-sonnet-20241022",
        display_name: "Claude 3.5 Sonnet 2024-10-22",
        provider: :anthropic,
        client_class: LLM::Clients::Anthropic,
        additional_default_required_parameters: {
          max_output_tokens: 8192
        }
      },
      {
        canonical_name: "claude-3-5-haiku-20241022",
        display_name: "Claude 3.5 Haiku 2024-10-22",
        provider: :anthropic,
        client_class: LLM::Clients::Anthropic,
        additional_default_required_parameters: {
          max_output_tokens: 8192
        }
      },
      {
        canonical_name: "claude-3-5-sonnet-20240620",
        display_name: "Claude 3.5 Sonnet 2024-06-20",
        provider: :anthropic,
        client_class: LLM::Clients::Anthropic,
        additional_default_required_parameters: {
          max_output_tokens: 8192
        }
      },
      {
        canonical_name: "claude-3-opus-20240229",
        display_name: "Claude 3.5 Opus 2024-02-29",
        provider: :anthropic,
        client_class: LLM::Clients::Anthropic,
        additional_default_required_parameters: {
          max_output_tokens: 4096
        }
      },
      {
        canonical_name: "claude-3-sonnet-20240229",
        display_name: "Claude 3.5 Sonnet 2024-02-29",
        provider: :anthropic,
        client_class: LLM::Clients::Anthropic,
        additional_default_required_parameters: {
          max_output_tokens: 4096
        }
      },
      {
        canonical_name: "claude-3-haiku-20240307",
        display_name: "Claude 3.5 Opus 2024-03-07",
        provider: :anthropic,
        client_class: LLM::Clients::Anthropic,
        additional_default_required_parameters: {
          max_output_tokens: 4096
        }
      },
      {
        canonical_name: "gemini-1.5-flash",
        display_name: "Gemini 1.5 Flash",
        provider: :google,
        client_class: LLM::Clients::Gemini
      },
      {
        canonical_name: "gemini-1.5-pro",
        display_name: "Gemini 1.5 Pro",
        provider: :google,
        client_class: LLM::Clients::Gemini
      }
    ].freeze
  end
end
