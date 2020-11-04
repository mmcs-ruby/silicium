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
###   Graphs

#### Graph initialization
To create an empty graph just initialize an object:
```ruby
    g = OrientedGraph.new
    g = UnorientedGraph.new
````
Of course, you can determine vertices (name them whatever you want!). To do that, write something like:
```ruby
    g = OrientedGraph.new([{v: 0,     i: [:one]},
                          {v: :one,  i: [0, 'two']},
                          {v: 'two', i: [0, 'two']}])
```
You have to pass an `Array` of `Hashes`, each hash consists of pair of keys:
* v: vertex name;
* i: `Array` of adjacent vertices

Same goes for the case with unoriented graph (note that missing edges will be added automatically):
```ruby
    g = UnorientedGraph.new([{v: 0,     i: [:one]},
                           {v: :one,  i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])``
```

#### Graph Methods:
* Add vertex to your graph:
```ruby
    g.add_vertex!(Vertex)
```
* Add edge to your graph:
```ruby
    g.add_edge!(vertex_from, vertex_to)
```
* Get vertices adjacted with vertex: 
```ruby
    g.adjacted_with(vertex)
```
* Set label for the edge:
 ```ruby
     g.label_edge!(vertex_from, vertex_to, label)
 ```
* Get label for the edge:
 ```ruby
     g.get_edge_label(vertex_from, vertex_to)
 ```
* Set label for the vertex:
 ```ruby
     g.label_vertex!(vertex, label)
 ```
* Get label for the vertex:
 ```ruby
     g.get_vertex_label(vertex)
 ```
* Get number of vertices:
 ```ruby
     g.vertex_number
 ```
* Get number of edges:
 ```ruby
     g.edge_number
 ```
* Get number of vertex labels:
 ```ruby
     g.vertex_label_number
 ```
* Get number of vertex edges:
 ```ruby
     g.edge_label_number
 ```
* Check whether graph contains vertex:
 ```ruby
     g.has_vertex?(vertex)
 ```
* Check whether graph contains edge: 
 ```ruby
     g.has_edge?(vertex_from, vertex_to)
 ```
* Delete vertex:
 ```ruby
     g.delete_vertex!(vertex)
 ```
* Delete edge:
 ```ruby
     g.delete_edge!(vertex_from, vertex_to)
 ```
* Get array of vertices:
 ```ruby
     g.vertices
 ```

#### Graph algorithms:

* Check whether graph is connected:
 ```ruby
     g.connected?(graph)
 ```
* Breadth-First Search:
 ```ruby
     g.breadth_first_search?(graph, starting_vertex, searching_vertex)
 ```
* Algorithm of Dijkstra:
```ruby
     g.dijkstra_algorythm!(graph, starting_vertex)
```  
* Find Strongly Connected Components:
```ruby
     g.find_strongly_connected_components
```

* Topological sort

#### Description
Topological sorting for Directed Acyclic Graph (DAG) is a linear ordering of vertices such that for every directed edge *u v*, vertex *u* comes before *v* in the ordering.

#### How to use
For you to have a topologically sorted graph, you need to create an object of the class ```Graph```:
``` ruby
    graph = Graph.new
```
Then you need to add vertices to this graph using the class ```Node```:
``` ruby
    graph.nodes << (node1 = Node.new(1))
    graph.nodes << (node2 = Node.new(2))
```
Due to the fact that only a directed graph can be sorted topologically, it is necessary to add an edge:
``` ruby
    graph.add_edge(node1, node2)
```
And finally you can type:
``` ruby
    TopologicalSortClass.new(graph)
```

#### Result
The result for ```TopologicalSortClass.new(graph).post_order.map(&:to_s)``` is [2, 1]

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
=======
### Numerical integration

Library `Numerical integration` 
includes methods for numerical integration of functions, such as 3/8 method, Simpson method, left, right and middle rectangle methods and trapezoid method.

Each function accepts 4 parameters, such as left and right integration boundaries, default accuracy of 0.0001 and the function itself.
Example: `three_eights_integration(4, 5, 0.01) { |x| 1 / x }` or `three_eights_integration(4, 5) { |x| 1 / x }`

For example, to integrate 1 / x  in between [4, 5] using the 3/8 method, you need to use: 
`NumericalIntegration.three_eights_integration(4, 5) { |x| 1 / x }`

using the Simpson's method: 
`NumericalIntegration.simpson_integration(4, 5) {  |x| 1 / x  }`

using the left rectangle method: 
`NumericalIntegration.left_rect_integration(4, 5) {  |x| 1 / x  }`

using the right rectangle method: 
`NumericalIntegration.right_rect_integration(4, 5) {  |x| 1 / x  }`

using the middle rectangle method:
`NumericalIntegration.middle_rectangles(4, 5) {  |x| 1 / x  }`

using the trapezoid method: 
`NumericalIntegration.trapezoid(4, 5) {  |x| 1 / x  }`

### Theory of probability

#### Combinatorics
Module with usual combinatorics formulas
```
    factorial(5) # 5! = 120
    combination(n, k) # C(n, k) = n! / (k! * (n-k)!)
    arrangement(n, k) # A(n, k) = n! / (n - k)!
```
#### Module Dice

Module describing both ordinary and unique dices 

You can initialize a Polyhedron by two ways

first: by number - Polyhedron.new(6) - creates polyhedron with 6 sides [1,2,3,4,5,6]

second: by array - Polyhedron.new([1,3,5]) - creates polyhedron with 3 sides [1,3,5]
```
class Polyhedron
    csides # sides number
    sides  # array of sides
    throw # method of random getting on of the Polyhedron's sides
```

Example

```
d = Polyhedron.new(8)
d.csides # 8
d.sides # [1,2,3,4,5,6,7,8]
d.throw # getting random side (from 1 to 8)

d1 = Polyhedron.new([1,3,5,6])
d1.csides # 4
d1.sides # [1,3,5,6]
d1.throw # getting random side (from 1 or 3 or 5 or 8)
```

#### Class PolyhedronSet

You can initialize PolyhedronSet by array of:

Polyhedrons

Number of Polyhedron's sides

Array of sides
```
class PolyhedronSet
    percentage # hash with chances of getting definite score
    throw   # method of getting points from throwing polyhedrons
    make_graph_by_plotter # creating graph introducing chances of getting score
```

Example

```
s = PolyhedronSet.new([6, [1,2,3,4,5,6], Polyhedron.new(6)]) 

s.percentage # {3=>0.004629629629629629, 4=>0.013888888888888888, 5=>0.027777777777777776, 6=>0.046296296296296294, 
              # 7=>0.06944444444444445, 8=>0.09722222222222222, 9=>0.11574074074074074, 
              # 10=>0.125, 11=>0.125, 12=>0.11574074074074074, 13=>0.09722222222222222, 14=>0.06944444444444445, 
              # 15=>0.046296296296296294, 16=>0.027777777777777776, 17=>0.013888888888888888, 18=>0.004629629629629629}    

s.throw   # getting random score (from 3 to 18)

s.make_graph_by_plotter(xsize, ysize) # creates a graph in 'tmp/percentage.png'
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
