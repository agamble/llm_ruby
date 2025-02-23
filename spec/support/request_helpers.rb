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
      model_file_name(example)
    ].join("/")
    VCR.use_cassette(cassette, &)
  end

  def parent_groups(example)
    example.example_group.parent_groups.reverse.map(&:description)
      .map { |s| s.gsub(/[^0-9a-z ]/i, "") }.join(" ")
  end

  def model_file_name(example)
    parts = [parent_groups(example), example.description].flatten
    while parts.join("_").length > 250
      parts.shift
    end
    parts.join("_")
  end
end
