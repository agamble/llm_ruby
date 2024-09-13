# frozen_string_literal: true

module LLM::Info
  KNOWN_MODELS = [
    # Semantics of fields:
    # - canonical_name (required): A string that uniquely identifies the model.
    #   We use this string as the public identifier when users choose this model via the API.
    # - display_name (required): A string that is displayed to the user when choosing this model via the UI.

    # GPT-3.5 Turbo Models
    {
      canonical_name: "gpt-3.5-turbo",
      display_name: "GPT-3.5 Turbo",
      provider: :openai
    },
    {
      canonical_name: "gpt-3.5-turbo-0125",
      display_name: "GPT-3.5 Turbo 0125",
      provider: :openai
    },
    {
      canonical_name: "gpt-3.5-turbo-16k",
      display_name: "GPT-3.5 Turbo 16K",
      provider: :openai
    },
    {
      canonical_name: "gpt-3.5-turbo-1106",
      display_name: "GPT-3.5 Turbo 1106",
      provider: :openai
    },

    # GPT-4 Models
    {
      canonical_name: "gpt-4",
      display_name: "GPT-4",
      provider: :openai
    },
    {
      canonical_name: "gpt-4-32k",
      display_name: "GPT-4 32K",
      provider: :openai
    },
    {
      canonical_name: "gpt-4-1106-preview",
      display_name: "GPT-4 Turbo 1106",
      provider: :openai
    },
    {
      canonical_name: "gpt-4-turbo-2024-04-09",
      display_name: "GPT-4 Turbo 2024-04-09",
      provider: :openai
    },
    {
      canonical_name: "gpt-4-0125-preview",
      display_name: "GPT-4 Turbo 0125",
      provider: :openai
    },
    {
      canonical_name: "gpt-4-turbo-preview",
      display_name: "GPT-4 Turbo",
      provider: :openai
    },
    {
      canonical_name: "gpt-4-0613",
      display_name: "GPT-4 0613",
      provider: :openai
    },
    {
      canonical_name: "gpt-4-32k-0613",
      display_name: "GPT-4 32K 0613",
      provider: :openai
    },
    {
      canonical_name: "gpt-4o",
      display_name: "GPT-4o",
      provider: :openai
    },
    {
      canonical_name: "gpt-4o-mini",
      display_name: "GPT-4o Mini",
      provider: :openai
    },
    {
      canonical_name: "gpt-4o-2024-05-13",
      display_name: "GPT-4o 2024-05-13",
      provider: :openai
    },
    {
      canonical_name: "gpt-4o-2024-08-06",
      display_name: "GPT-4o 2024-08-06",
      provider: :openai
    },
    {
      canonical_name: 'claude-3-5-sonnet-20240620',
      display_name: 'Claude 3.5 Sonnet 2024-06-20',
      provider: :anthropic
    },
  ].freeze
end
