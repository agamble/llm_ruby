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

    def gemini_response_format
      transform_schema(@schema)
    end

    def transform_schema(schema)
      # Initialize the result as an empty hash.
      openapi_schema = {}

      # Process the "type" field and handle nullability.
      if schema.key?("type")
        if schema["type"].is_a?(Array)
          # Check for "null" in the type array to mark the schema as nullable.
          if schema["type"].include?("null")
            openapi_schema["nullable"] = true
            # Remove "null" from the type array; if a single type remains, use that.
            remaining_types = schema["type"] - ["null"]
            openapi_schema["type"] = (remaining_types.size == 1) ? remaining_types.first : remaining_types
          else
            openapi_schema["type"] = schema["type"]
          end
        else
          openapi_schema["type"] = schema["type"]
        end
      end

      # Map simple fields directly: "format", "description", "enum", "maxItems", "minItems".
      ["format", "description", "enum", "maxItems", "minItems"].each do |field|
        openapi_schema[field] = schema[field] if schema.key?(field)
      end

      # Recursively process "properties" if present.
      if schema.key?("properties") && schema["properties"].is_a?(Hash)
        openapi_schema["properties"] = {}
        schema["properties"].each do |prop, prop_schema|
          openapi_schema["properties"][prop] = transform_schema(prop_schema)
        end
      end

      # Copy "required" if present.
      openapi_schema["required"] = schema["required"] if schema.key?("required")

      # Copy "propertyOrdering" if present (non-standard field).
      openapi_schema["propertyOrdering"] = schema["propertyOrdering"] if schema.key?("propertyOrdering")

      # Recursively process "items" for array types.
      if schema.key?("items")
        openapi_schema["items"] = transform_schema(schema["items"])
      end

      openapi_schema
    end
  end
end
