# Tenios

Wraps [Tenios Call Control](https://www.tenios.de/en/doc/api-spec) blocks in ruby.
Each accepted block has a corresponding object under `Tenios::Blocks`, currently these are:
- `Tenios::Blocks::Announcement`
- `Tenios::Blocks::Bridge`
- `Tenios::Blocks::CollectDigits`
- `Tenios::Blocks::CollectSpeech`
- `Tenios::Blocks::HangUp`
- `Tenios::Blocks::RoutingPlan`
- `Tenios::Blocks::Say`

Each of these can be used as part of a `Tenios::Blocks` object, by using `Tenios::Blocks#add`.

`Tenios::Blocks` implements `#as_json` which returns a JSON-like hash (although with symbolised keys).

In rails you can pass the `Tenios::Blocks` object directly to `render` under the `json:` key.

```ruby
require 'tenios'

class TeniosController < ApplicationController
  def empty_response
    announcement = Tenios::Blocks::Announcement.new(announcement: 'redirect', standard: false)
    bridge = Tenios::Blocks::Bridge.new(mode: Tenios::Blocks::Bridge::SEQUENTIAL) do |redirect|
      redirect.with_destination(Tenios::Blocks::Bridge::EXTERNAL_NUMBER, '+440123456789', 10)
    end

    blocks = Tenios::Blocks.new do |response|
      response.add(announcement)
      response.add(bridge)
    end

    render json: blocks
  end
end
```

Else you can use any JSON serializer that can deal with a ruby `Hash`

```ruby
require 'json'
require 'tenios'

announcement = Tenios::Blocks::Announcement.new(announcement: 'redirect', standard: false)
bridge =
  Tenios::Blocks::Bridge
  .new(mode: Tenios::Blocks::Bridge::SEQUENTIAL)
  .with_destination(Tenios::Blocks::Bridge::EXTERNAL_NUMBER, '+440123456789', 10)

Tenios::Blocks.new
.add(announcement)
.add(bridge)
.as_json
.yield_self { |hash| JSON.generate(hash) }
```

As you may have noticed in the exampled above you can both chain calls to `Tenios::Blocks#add` and `Tenios::Blocks::Bridge#with_destination` or pass a block to those initialisers. :man_shrugging: whatever floats your boat.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tenios'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tenios

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/carwow/tenios-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
