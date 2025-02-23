# frozen_string_literal: true

module RequestHelpers
  def with_vcr(example, &)
    cassette = [
      parent_groups(example),
      example.description
    ].flatten
    VCR.use_cassette(cassette, &)
  end

  def with_vcr_for_model(model, example, &)
    cassette = [
      model.provider.to_s,
      model.canonical_name,
      [parent_groups(example), example.description].flatten.join("_")
    ].join("/")
    VCR.use_cassette(cassette, &)
  end

  def parent_groups(example)
    example.example_group.parent_groups.reverse.map(&:description)
      .map { |s| s.gsub(/[^0-9a-z ]/i, "") }.join(" ")
  end
end
