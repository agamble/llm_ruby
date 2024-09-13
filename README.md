# LLMRuby

LLMRuby is a Ruby gem that provides a consistent interface for interacting with various Large Language Model (LLM) APIs, with a current focus on OpenAI's models.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'llm_ruby'
```

And then execute:

```
bundle install
```

Or install it yourself as:

```
gem install llm_ruby
```

## Usage

### Basic Usage

```ruby
require 'llm'

# Initialize an LLM instance
llm = LLM.from_string!("gpt-4")

# Create a client
client = llm.client

# Send a chat message
response = client.chat([{role: :user, content: "Hello, world!"}])

puts response.content
```

### Streaming Responses

LLMRuby supports streaming responses:

```ruby
require 'llm'

# Initialize an LLM instance
llm = LLM.from_string!("gpt-4")

# Create a client
client = llm.client

# Define the on_message callback
on_message = proc do |message|
  puts "Received message chunk: #{message}"
end

# Define the on_complete callback
on_complete = proc do |stop_reason|
  puts "Streaming complete. Stop reason: #{stop_reason}"
end

# Send a chat message with streaming enabled
response = client.chat(
  [{role: :user, content: "Hello, world!"}],
  stream: true,
  on_message: on_message,
  on_complete: on_complete
)

puts response.content
```

### Using the Response Object

The response object returned by the `client.chat` method contains several useful fields:

- `content`: The final content of the response.
- `raw_response`: The raw response payload for non-streaming requests and the array of chunks for streaming requests.
- `stop_reason`: The reason why the response generation was stopped.

Here is an example of how to use the response object:

```ruby
# Initialize an LLM instance
llm = LLM.from_string!("gpt-4")

# Create a client
client = llm.client

# Send a chat message
response = client.chat([{role: :user, content: "Hello, world!"}])

# Access the response fields
puts "Response content: #{response.content}"
puts "Raw response: #{response.raw_response}"
puts "Stop reason: #{response.stop_reason}"
```

## Available Models

LLMRuby supports various OpenAI models, including GPT-3.5 and GPT-4 variants. You can see the full list of supported models in the `KNOWN_MODELS` constant:

| Canonical Name             | Display Name                  | Provider  |
|----------------------------|-------------------------------|-----------|
| gpt-3.5-turbo              | GPT-3.5 Turbo                 | openai    |
| gpt-3.5-turbo-0125         | GPT-3.5 Turbo 0125            | openai    |
| gpt-3.5-turbo-16k          | GPT-3.5 Turbo 16K             | openai    |
| gpt-3.5-turbo-1106         | GPT-3.5 Turbo 1106            | openai    |
| gpt-4                      | GPT-4                         | openai    |
| gpt-4-32k                  | GPT-4 32K                     | openai    |
| gpt-4-1106-preview         | GPT-4 Turbo 1106              | openai    |
| gpt-4-turbo-2024-04-09     | GPT-4 Turbo 2024-04-09        | openai    |
| gpt-4-0125-preview         | GPT-4 Turbo 0125              | openai    |
| gpt-4-turbo-preview        | GPT-4 Turbo                   | openai    |
| gpt-4-0613                 | GPT-4 0613                    | openai    |
| gpt-4-32k-0613             | GPT-4 32K 0613                | openai    |
| gpt-4o                     | GPT-4o                        | openai    |
| gpt-4o-mini                | GPT-4o Mini                   | openai    |
| gpt-4o-2024-05-13          | GPT-4o 2024-05-13             | openai    |
| gpt-4o-2024-08-06          | GPT-4o 2024-08-06             | openai    |
| claude-3-5-sonnet-20240620 | Claude 3.5 Sonnet 2024-06-20  | anthropic |
| claude-3-opus-20240229     | Claude 3.5 Opus 2024-02-29    | anthropic |
| claude-3-sonnet-20240229   | Claude 3.5 Sonnet 2024-02-29  | anthropic |
| claude-3-haiku-20240307    | Claude 3.5 Opus 2024-03-07    | anthropic |

## Configuration

Set your OpenAI API key as an environment variable:

```
export OPENAI_API_KEY=your_api_key_here
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/contextco/llm_ruby>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Acknowledgements

This gem is developed and maintained by [Context](https://context.ai).
