# Ara2yml

Convert proprietary file format of [Across v6](http://www.my-across.net/en/download-center.aspx) for exporting and (re-)importing projects into the YAML.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ara2yml'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ara2yml

Also, it requires `mdbtools` package.

    sudo apt-get install mdbtools

## Usage

CLI

    ara2yml /tmp/ara /tmp/yml

API

    Ara2yml.convert(ara_filename, yml_filename)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ara2yml/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
