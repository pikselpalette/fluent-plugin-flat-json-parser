require 'helper'
require 'fluent/test'
require 'fluent/parser'
require 'fluent/plugin/parser_flat_json'

CONFIG_NONE = {}

CONFIG_TIME_KEY = {
  "time_key" => "timestamp"
}
CONFIG_TIME_FORMAT = {
  "time_key" => "timestamp",
  "time_format" => "%Y%m%d%H:%M:%S"
}

def create_driver(conf = CONFIG_NONE)
  parser = Fluent::TextParser::JSONFlatParser.new
  parser.configure(conf)
  parser
end

class JSONFlatParserTest < Test::Unit::TestCase

  def test_format_metrics
    rec = '{"timestamp": "1418973586", "log": [{"foo": "bar"}, {"baz": "quux"}], "next": ["a", "b"]}'
    expected = {
      "log.0.foo" => "bar",
      "log.1.baz" => "quux",
      "next.0" => "a",
      "next.1" => "b"
    }

    d = create_driver(CONFIG_TIME_KEY)
    d.call(rec) { |time, record|
      assert_equal(time, 1418973586)
      assert_equal(record, expected)
    }

  end
end
