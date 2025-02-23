# frozen_string_literal: true

module RequestHelpers
  def with_vcr(example, &)
    cassette = [
      example.example_group.parent_groups.reverse.map(&:description)
        .map { |s| s.gsub(/[^0-9a-z ]/i, "") }.join(" "), example.description
    ].flatten
    VCR.use_cassette(cassette, &)
  end
end
