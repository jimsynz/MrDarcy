# MrDarcy

A mashup of Async Promises and DCI in ruby.

![Build Status](https://www.codeship.io/projects/baa3c520-a0e3-0131-f32f-26748b0e5360/status)

## Installation

Add this line to your application's Gemfile:

    gem 'mr_darcy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mr_darcy

## Usage

### Such promise. Many then.

Promises are a way of structuring batches of (async) functionality into a
pipeline, in such a way as to make them seem synchronous.

Here's an example:

```ruby
# We're going to wrap an asynchronous web request using EventMachine
# in a promise:
data = MrDarcy::Promise.new do
  EM.run do
    http = EM.HttpRequest.new('http://camp.ruby.org.nz/').get
    http.errback do
      reject http.error
      EM.stop
    end
    http.callback do
      resolve http.response
      EM.stop
    end
  end
end.then do |response|
  response.body
end.result

puts data
```


## Contributing

1. Fork it ( http://github.com/<my-github-username>/mr_darcy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
