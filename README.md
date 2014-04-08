# MrDarcy

A mashup of Async Promises and DCI in ruby.

![Build Status](https://www.codeship.io/projects/baa3c520-a0e3-0131-f32f-26748b0e5360/status)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mr_darcy'
```

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
data = MrDarcy.promise do
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

What's cool about MrDarcy is that we can switch between different methods of
doing async ruby:
  - Naive threads, using MRI's thread implementation.
  - Reactor pattern, using [EventMachine](http://rubyeventmachine.com/) to
    schedule promises on the a reactor thread.
  - Actor pattern, using [Celluloid](http://celluloid.io/) to run schedule
    promises using Celluloid futures.

Here's the promise cheatsheet:

  1. You create them with a block, which is scheduled asynchronously, and
     inside of which you can place your long-running executable. Inside this
     block you call either `resolve <value>` or `reject <exception>` to resolve
     or reject the promise.

     ```ruby
     MrDarcy.promise do
       accellerate_the_delorean
       if speed >= 88
         resolve :time_flux_initiated
       else
         reject :engage_service_brake
       end
     end
     ```

  2. All promises have `then` and `fail` methods, to which you pass a block to
     be called when the promise resolves (`then`) or rejects (`fail`). These
     methods return new promises, upon which you can chain more `then` and
     `fail` calls.

     ```ruby
     MrDarcy.promise do
       resolve 2
     end.then |value|
       value * value
     end
     ```

  3. Promises returned by `fail` will resolve successfully with the new result
     of the block, unless the block raises also.

     ```ruby
     MrDarcy.promise do
       reject 2
     end.fail |value|
       value * value
     end.then |value|
       # I am called with 4
     end
     ```

  4. Failures cascade until they're caught:

     ```ruby
     MrDarcy.promise do
       reject :fail
     end.then
       # I am skipped
     end.then
       # as am I
     end.fail
       # I am called
     end
     ```

  5. If your block returns a new promise, then `then` or `fail` will defer
     their resolution until the new promise is resolved:

     ```ruby
     MrDarcy.promise do
       resolve 1
     end.then do |value|
       MrDarcy.promise do
         resolve value * 2
       end
     end.then |value|
       # I will be called with 2
     end
     ```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/mr_darcy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
