# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "llm_ruby"
  spec.version = "0.2.0"
  spec.authors = ["Alex Gamble"]

  spec.summary = "A client to interact with LLM APIs in a consistent way."
  spec.homepage = "https://github.com/agamble/llm_ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/agamble/llm_ruby"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "event_stream_parser", "~> 1.0.0"
  spec.add_dependency "httparty", "~> 0.22.0"
  spec.add_dependency "zeitwerk", "~> 2.6.0"

  spec.add_development_dependency "dotenv", "~> 3.1.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "standard", "~> 1.31.0"
  spec.add_development_dependency "vcr", "~> 6.3.1"
  spec.add_development_dependency "webmock", "~> 3.23.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
