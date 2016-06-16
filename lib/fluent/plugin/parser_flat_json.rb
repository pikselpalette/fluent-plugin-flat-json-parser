module Fluent
  class TextParser
    class JSONFlatParser < JSONParser

      config_param :separator, :string, :default => '.'

      def flatten_with_path(nested, parent_prefix = nil)
        res = {}

        nested.each_with_index do |elem, i|
          if elem.is_a?(Array)
            k, v = elem
          else
            k, v = i, elem
          end

          key = parent_prefix ? "#{parent_prefix}#{@separator}#{k}" : k # assign key name for result hash
          key = key.gsub('.', @separator)

          if v.is_a? Enumerable
            res.merge!(flatten_with_path(v, key)) # recursive call to flatten child elements
          else
            res[key] = v
          end
        end

        res
      end

      def call(text)
        record = Yajl.load(text)

        if value = record.delete(@time_key)
          if @time_format == 'ms'
            time = (value.to_i / 1000).to_i
	    timestamp = Time.at(value.to_f / 1000).strftime('%FT%T.%3N%:z').to_s
	  elsif @time_format
            time = @mutex.synchronize { @time_parser.parse(value) }
            timestamp = Time.at(time).to_s
          else
            time = value.to_i
            timestamp = Time.at(time).to_s
          end
        else
          if @estimate_current_event
            time = Engine.now
            timestamp = Time.at(time).to_s
          else
            time = nil
            timestamp = nil
          end
        end
        record = flatten_with_path(record)
	record['@timestamp'] = timestamp if timestamp

        if block_given?
          yield time, record
        else
          return time, record
        end
      rescue Yajl::ParseError
        if block_given?
          yield nil, nil
        else
          return nil, nil
        end
      end
    end

    # Add JSONFlatParser to the registry
    register_template("flat_json", Proc.new { JSONFlatParser.new })
  end
end
