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

###Sparse matrix

####Class SparseMatrix

Matrix is stored as array of triplets. 
Triplet = [i , j , elem], where i - row index, j - col index , elem - element value.

You can initialize sparse matrix by two ways :
1) By its size - SparseMatrix.new(n,m)   // n - count of rows , m - count of cols.
2) From a regular matrix - SparseMatrix.sparse(mat)   // mat - regular matrix

Example :

Initialize sparse matrix : 
```ruby
      sm = SparseMatrix.new(3, 4)
      mat = [[1, 0, 0],
             [2, 0, 0],
             [0, 0, 3]]
      sm1 = SparseMatrix.sparse(mat)  
```

Add , copy , get , transpose , show etc :
```ruby
      sm.add(0, 1, 2)
      sm.add(1, 0, 1)
      sm.add(2, 1, 3)

      sm1 = sm.copy  # a copy of matrix object

      x = sm.get(0, 1) # x = 2

      smt = sm.transpose  # a transposed copy of matrix

      s = sm.show # It looks like ╔═══════════════════╗
                  #               ║   0   2   0   0   ║
                  #               ║   1   0   0   0   ║
                  #               ║   0   3   0   0   ║
                  #               ╚═══════════════════╝
                  # but actually s = "╔═══════════════════╗\n║   0   \e[#{32}m#{2}\e[0m   0   0   ║\n║   \e[#{32}m#{1}\e[0m   0   0   0   ║\n║   0   \e[#{32}m#{3}\e[0m   0   0   ║\n╚═══════════════════╝\n"
                  # because not null elems colorized green 
 
      sm = sm.adding(sm1)  # sum of two matrix

      arr = sm.multiply(sm1)  # Returns a matrix in its regular view but multiplied by other matrix
```


 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mmcs-ruby/silicium. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Silicium project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/silicium/blob/master/CODE_OF_CONDUCT.md).
