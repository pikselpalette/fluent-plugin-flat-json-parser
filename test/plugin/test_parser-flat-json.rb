require 'helper'
require 'fluent/test'
require 'fluent/parser'
require 'fluent/plugin/parser_flat_json'

CONFIG_NONE = {}

CONFIG_TIME_KEY = {
  "time_key" => "timestamp"
}
CONFIG_TIME_KEY_MS = {
  "time_key" => "timestamp",
  "time_format" => "ms"
}
CONFIG_TIME_FORMAT = {
  "time_key" => "timestamp",
  "time_format" => "%Y%m%d%H%M%S"
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
      "log.0.foo"  => "bar",
      "log.1.baz"  => "quux",
      "next.0"     => "a",
      "next.1"     => "b",
      "@timestamp" => "2014-12-19 07:19:46 +0000",
    }

    d = create_driver(CONFIG_TIME_KEY)
    d.call(rec) { |time, record|
      assert_equal(1418973586, time)
      assert_equal(expected, record)
    }

  end

  def test_format_metrics_with_time_format_in_ms
    rec = '{"timestamp": "1418973586001", "log": [{"foo": "bar"}, {"baz": "quux"}], "next": ["a", "b"]}'
    expected = {
      "log.0.foo"  => "bar",
      "log.1.baz"  => "quux",
      "next.0"     => "a",
      "next.1"     => "b",
      "@timestamp" => "2014-12-19T07:19:46.000+00:00",
    }

    d = create_driver(CONFIG_TIME_KEY_MS)
    d.call(rec) { |time, record|
      assert_equal(1418973586, time)
      assert_equal(expected, record)
    }

  end

  def test_format_metrics_with_time_format
    rec = '{"timestamp": "20141219071946", "log": [{"foo": "bar"}, {"baz": "quux"}], "next": ["a", "b"]}'
    expected = {
      "log.0.foo"  => "bar",
      "log.1.baz"  => "quux",
      "next.0"     => "a",
      "next.1"     => "b",
      "@timestamp" => "2014-12-19 07:19:46 +0000",
    }

    d = create_driver(CONFIG_TIME_FORMAT)
    d.call(rec) { |time, record|
      assert_equal(1418973586, time)
      assert_equal(expected, record)
    }

  end
end
