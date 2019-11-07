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
*   Graph Section:

    Oriented Graph Initialization example:

    g = OrientedGraph.new([{v: 0,     i: [:one]},
                          {v: :one,  i: [0, 'two']},
                          {v: 'two', i: [0, 'two']}])

    Unoriented Graph Initialization example:

    g = UnorientedGraph.new([{v: 0,     i: [:one]},
                           {v: :one,  i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])


    Graph Methods:

    Add vertex: add_vertex!(Vertex)

    Add edge: add_edge!(vertex_from, vertex_to)


    Get vertices adjacted with vertex: adjacted_with(vertex)


    Set label for edge: label_edge!(vertex_from, vertex_to, label)

    Get label for edge: get_edge_label(vertex_from, vertex_to)

    Set label for vertex: label_vertex!(vertex, label)

    Get label for vertex: get_vertex_label(vertex)


    Get number of vertices: vertex_number

    Get number of edges: edge_number

    Get number of vertex labels: vertex_label_number

    Get number of vertex edges:edge_label_number


    Check if graph contains vertex: has_vertex?(vertex)

    Check if graph contains edge: has_edge?(vertex_from, vertex_to)


    Delete vertex: delete_vertex!(vertex)

    Delete edge: delete_edge!(vertex_from, vertex_to)


    Get array of vertices: vertices


    Algorithms for graphs:

    Check if graph is connected: connected?(graph)

    BFS: breadth_first_search?(graph, starting_vertex, searching_vertex)

    Algorithm of Dijkstra: dijkstra_algorythm!(graph, starting_vertex)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/silicium. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Silicium project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/silicium/blob/master/CODE_OF_CONDUCT.md).
