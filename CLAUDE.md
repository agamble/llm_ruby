# LLM Ruby Development Guide

## Build & Test Commands
- Setup: `bin/setup`
- Install locally: `bundle exec rake install`
- Run all tests: `bundle exec rake spec`
- Run single test: `bundle exec rspec spec/path/to_spec.rb:LINE_NUMBER`
- Run linter: `bundle exec rake standard`
- Interactive console: `bin/console`

## Code Style Guidelines
- Use `frozen_string_literal: true` at the top of all Ruby files
- Follow Standard Ruby style (`standard` gem)
- Naming: snake_case for methods/variables, CamelCase for classes
- Use double quotes consistently for strings
- Explicit returns are optional (prefer implicit returns when possible)
- Class organization: constants first, then class methods, then initialize, then instance methods
- Keep methods and classes small and focused (single responsibility)
- Cover all code with tests in the `spec` directory
- API credentials should be read from environment variables
- Use proper type inflection (e.g., "llm" => "LLM", "open_ai" => "OpenAI")
- Use VCR/webmock for testing HTTP interactions