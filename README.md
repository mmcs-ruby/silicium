[![Gem Version](https://badge.fury.io/rb/silicium.svg)](https://badge.fury.io/rb/silicium)
[![Build Status](https://travis-ci.org/mmcs-ruby/silicium.svg?branch=master)](https://travis-ci.org/mmcs-ruby/silicium)
[![Maintainability](https://api.codeclimate.com/v1/badges/b0ec4b3029f90d4273a1/maintainability)](https://codeclimate.com/github/mmcs-ruby/silicium/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/b0ec4b3029f90d4273a1/test_coverage)](https://codeclimate.com/github/mmcs-ruby/silicium/test_coverage)

# Silicium

Ruby Math Library written as exercise by MMCS students.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'silicium'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install silicium

## Usage

### Plotter

#### Determine your function

```ruby
def fn(x)
  x**2
end
```

#### Set scale

```ruby
# 1 unit is equal 40 pixels
set_scale(40)
```

#### Draw you function

```ruby
draw_fn(-20, 20) {|args| fn(args)}
```

#### Show your plot

```ruby
show_window
```

#### Result

![Alt-текст](./plot.png "Result")

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mmcs-ruby/silicium. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Silicium project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/silicium/blob/master/CODE_OF_CONDUCT.md).
