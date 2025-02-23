class LLM
  class Schema
    def initialize(name, schema)
      @name = name
      @schema = schema
    end

    def self.from_file(file_path)
      new(File.basename(file_path, ".json"), JSON.parse(File.read(file_path)))
    end

    def response_format
      {
        type: "json_schema",
        json_schema: {
          name: @name,
          strict: true,
          schema: @schema
        }
      }
    end
  end
end
