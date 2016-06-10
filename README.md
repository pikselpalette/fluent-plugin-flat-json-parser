# fluent-plugin-flat-json-parser [![Build Status](https://travis-ci.org/pikselpalette/fluent-plugin-flat-json-parser.png)](https://travis-ci.org/pikselpalette/fluent-plugin-flat-json-parser)

fluentd parser plugin to create flattened JSON from nested JSON objects

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-flat-json-parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-flat-json-parser

## Configuration

#### Example

Log line: '{"event":"request","timestamp":1418933352405,"instance":"http://ip-10-203-12-5:3000","labels":["admin"],"method":"get","path":"/","query":{},"source":{"remoteAddress":"10.203.12.11","userAgent":"ELB-HealthChecker/1.0"},"responseTime":1,"statusCode":200,"pid":575,"log":[{"request":"1418933352405-575-36980","timestamp":1418933352405,"tags":["hapi","received"],"data":{"id":"1418933352405-575-36980","method":"get","url":"/","agent":"ELB-HealthChecker/1.0"}},{"request":"1418933352405-575-36980","timestamp":1418933352405,"tags":["hapi","handler"],"data":{"msec":0.03636908531188965}},{"request":"1418933352405-575-36980","timestamp":1418933352406,"tags":["hapi","response"]}],"headers":{"host":"10.203.12.5:3000","user-agent":"ELB-HealthChecker/1.0","accept":"*/*","connection":"keep-alive"}}'

###### Specify time_key

- configuration

  ```
  <source>
    type tail
    path /tmp/output.json
    pos_file /tmp/output.log.pos
    tag logs
    format json_flat
    time_key timestamp
    separator .
  </source>
  ```

- output event

  ```
  {"event":"request","timestamp":1418933352405,"instance":"http://ip-10-203-12-5:3000","labels.0":"admin","method":"get","path":"/","source.remoteAddress":"10.203.12.11","source.userAgent":"ELB-HealthChecker/1.0","responseTime":1,"statusCode":200,"pid":575,"log.0.request":"1418933352405-575-36980","log.0.timestamp":1418933352405,"log.0.tags.0":"hapi","log.0.tags.1":"received","log.0.data.id":"1418933352405-575-36980","log.0.data.method":"get","log.0.data.url":"/","log.0.data.agent":"ELB-HealthChecker/1.0","log.1.request":"1418933352405-575-36980","log.1.timestamp":1418933352405,"log.1.tags.0":"hapi","log.1.tags.1":"handler","log.1.data.msec":0.03636908531188965,"log.2.request":"1418933352405-575-36980","log.2.timestamp":1418933352406,"log.2.tags.0":"hapi","log.2.tags.1":"response","headers.host":"10.203.12.5:3000","headers.user-agent":"ELB-HealthChecker/1.0","headers.accept":"*/*","headers.connection":"keep-alive"}
  ```

#### Parameter

###### time_key
- Default is `time`
- Field to use for time resolution

###### time_format
- Format string for logfile timestamp.

## Contributing

1. Fork it ( http://github.com/pikselpalette/fluent-plugin-flat-json-parser/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
