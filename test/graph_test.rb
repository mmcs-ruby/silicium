require 'test_helper'
require 'silicium_test'
require 'graph'

class GraphTest < SiliciumTest
  include Silicium::Graphs

  # def oriented_graph
  # g = OrientedGraph.new([{v: 0,     i: [:one]},
  # {v: :one,  i: [0,'two']},
  # {v: 'two', i: [0, 'two']}])
  # end

  # def unoriented_graph
  # g = UnorientedGraph.new([{v: 0,     i: [:one]},
  # {v: :one,  i: ['two']},
  # {v: 'two', i: [0, 'two']}])
  # end

  def test_default_constructor
    g = OrientedGraph.new
    assert_equal(g.vertex_number, 0)
  end

  def test_advanced_constructor
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    assert_equal(g.vertex_number, 3)

    assert(g.has_vertex?(0))
    assert(g.has_vertex?(:one))
    assert(g.has_vertex?('two'))

    assert(g.has_edge?(0, :one))
    assert(g.has_edge?(:one, 0))
    assert(g.has_edge?(:one, 'two'))
    assert(g.has_edge?('two', 0))
    assert(g.has_edge?('two', 'two'))
  end

  def test_reverse_graph_vertex
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.reverse!
    pred = g.vertex_number == 3 && g.has_vertex?(0) && g.has_vertex?(:one) && g.has_vertex?('two')
    assert(pred)
  end

  def test_reverse_graph_edges
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.reverse!
    pred = g.has_edge?(:one, 0) && g.has_edge?(0, :one) && g.has_edge?('two', :one) && g.has_edge?(0, 'two')
    pred = pred && g.has_edge?('two', 'two')
    assert(pred)
  end

  def test_reverse_label_edge
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.label_edge!(0, :one, :some_label)
    g.reverse!
    assert_equal(g.get_edge_label(:one, 0), :some_label)
  end

  def test_reverse_label_vertex
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.label_vertex!(:one, :some_label)
    g.reverse!
    g.label_vertex!(:one, :some_label)
  end

  def test_connected
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    assert(connected?(g))
  end

  def test_connected_failed
    g = OrientedGraph.new([{v: 0, i: []},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    assert(!connected?(g))
  end

  def test_number_of_connected_one
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    assert_equal(number_of_connected(g), 1)
  end

  def test_number_of_connected_two_1
    g = OrientedGraph.new([{v: 0, i: []},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    assert_equal(number_of_connected(g), 2)
  end

  def test_number_of_connected_two_2
    g = OrientedGraph.new([{v: 0, i: []},
                           {v: :one, i: ['two']},
                           {v: 'two', i: [0, 'two']}])

    assert_equal(number_of_connected(g), 2)
  end

  def test_number_of_connected_two_3
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0]},
                           {v: 'two', i: ['two']}])

    assert_equal(number_of_connected(g), 2)
  end

  def test_number_of_connected_three
    g = OrientedGraph.new([{v: 0, i: []},
                           {v: :one, i: []},
                           {v: 'two', i: []}])

    assert_equal(number_of_connected(g), 3)
  end

  def test_bfs_passed_1
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])
    assert(breadth_first_search?(g, 0, 'two'))
  end

  def test_bfs_passed_2
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    assert(breadth_first_search?(g, 'two', 0))
  end

  def test_bfs_failed_1
    g = OrientedGraph.new([{v: 0, i: []},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    assert(!breadth_first_search?(g, 0, 'two'))
  end

  def test_bfs_failed_2
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0]},
                           {v: 'two', i: [0, 'two']}])

    assert(!breadth_first_search?(g, 0, 'two'))
  end

  def test_add_vertex
    g = OrientedGraph.new
    g.add_vertex!(:one)
    assert_equal(g.vertex_number, 1)
    assert(g.has_vertex?(:one))

    g.add_vertex!(:two)
    assert_equal(g.vertex_number, 2)
    assert(g.has_vertex?(:one))
    assert(g.has_vertex?(:two))
  end

  def test_add_edge
    g = OrientedGraph.new([{v: 0, i: []},
                           {v: :one, i: []},
                           {v: 'two', i: []}])

    g.add_edge!(0, :one)

    assert(g.has_edge?(0, :one))
    assert(!g.has_edge?(:one, 0))
  end

  def test_adjacted_with
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    assert_equal(g.adjacted_with(:one), [0, 'two'].to_set)
  end

  def test_adjacted_with_can_not_change_graph
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])
    g.adjacted_with(0) << 'two'

    assert(!g.has_edge?(0, 'two'))
  end

  def test_label_edge
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.label_edge!(0, :one, :some_label)
    assert_equal(g.get_edge_label(0, :one), :some_label)
  end

  def test_label_vertex
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.label_vertex!(:one, :some_label)
    assert_equal(g.get_vertex_label(:one), :some_label)
  end

  def test_delete_vertex_with_label
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.label_vertex!(0, :some_label)
    g.delete_vertex!(0)

    pred = !g.has_vertex?(0) && g.vertex_number == 2 && g.vertex_label_number == 0
    assert(pred)
  end

  def test_delete_vertex_with_label_with_error
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.label_vertex!(0, :some_label)
    g.delete_vertex!(0)

    exception = assert_raises(GraphError) do
      g.get_vertex_label(0)
    end

    assert_match(/Graph does not contain vertex/, exception.message)
  end

  def test_delete_vertex_with_label_and_edge_label
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.label_edge!(0, :one, {'Flex' => :Ricardo_Milos})
    g.label_edge!(:one, 0, 2.82)
    g.label_edge!(:one, 'two', :ьыь)
    g.label_vertex!(:one, 'Эчпочмак')

    g.delete_vertex!(:one)

    pred = !g.has_vertex?(:one) && g.vertex_number == 2 && g.vertex_label_number == 0 && g.edge_label_number == 0
    assert(pred)
  end

  def test_delete_edge_with_label
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.label_edge!(0, :one, {'Flex' => :Ricardo_Milos})
    g.label_edge!(:one, 0, 2.82)
    g.label_edge!(:one, 'two', :ьыь)
    g.label_edge!('two', 0, 666)
    g.label_edge!('two', 'two', [19, 17])

    g.delete_edge!(0, :one)
    g.delete_edge!(:one, 0)
    g.delete_edge!(:one, 'two')
    g.delete_edge!('two', 0)
    g.delete_edge!('two', 'two')

    pred = g.edge_number == 0 && g.vertex_number == 3 && g.vertex_label_number == 0 && g.edge_label_number == 0
    pred = pred && !g.has_edge?(0, :one) && !g.has_edge?(:one, 0) && !g.has_edge?(:one, 'two') && !g.has_edge?('two', 0) && !g.has_edge?('two', 'two')
    assert(pred)
  end

  def test_delete_vertex_single_1
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(0)

    (pred = !g.has_vertex?(0)) && (g.vertex_number == 2)
    assert(pred)
  end

  def test_delete_vertex_single_2
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(:one)

    (pred = !g.has_vertex?(:one)) && (g.vertex_number == 2)
    assert(pred)
  end

  def test_delete_vertex_single_3
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_vertex!('two')

    (pred = !g.has_vertex?('two')) && (g.vertex_number == 2)
    assert(pred)
  end

  def test_delete_vertex_single_4
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(0)
    g.delete_vertex!(:one)

    (pred = !g.has_vertex?(0)) && !g.has_vertex?(:one) && (g.vertex_number == 1)
    assert(pred)
  end

  def test_delete_vertex_single_5
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(:one)
    g.delete_vertex!('two')

    (pred = !g.has_vertex?(:one)) && !g.has_vertex?('two') && (g.vertex_number == 1)
    assert(pred)
  end

  def test_delete_vertex_single_6
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(0)
    g.delete_vertex!('two')

    (pred = !g.has_vertex?(0)) && !g.has_vertex?('two') && (g.vertex_number == 1)
    assert(pred)
  end

  def test_delete_vertex_single_7
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(0)
    g.delete_vertex!(:one)
    g.delete_vertex!('two')

    (pred = !g.has_vertex?(0)) && !g.has_vertex?(:one) && !g.has_vertex?('two') && (g.vertex_number == 0)
    assert(pred)
  end

  def test_delete_vertex_and_check_edges_1
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])
    g.delete_vertex!(0)

    pred = !g.has_edge?(0, :one) && !g.has_edge?(:one, 0) && !g.has_edge?('two', 0) && (g.vertex_number == 2)
    assert(pred)
  end

  def test_delete_vertex_and_check_edges_2
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(:one)

    pred = !g.has_edge?(0, :one) && !g.has_edge?(:one, 0) && !g.has_edge?(:one, 'two') && (g.vertex_number == 2)
    assert(pred)
  end

  def test_delete_vertex_and_check_edges_3
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_vertex!('two')

    pred = !g.has_edge?(:one, 'two') && !g.has_edge?('two', 0) && !g.has_edge?('two', 'two') && (g.vertex_number == 2)
    assert(pred)
  end

  def test_delete_vertex_and_check_edges_4
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(0)
    g.delete_vertex!(:one)

    pred = !g.has_edge?(0, :one) && !g.has_edge?(:one, 0) && !g.has_edge?('two', 0) && !g.has_edge?(:one, 'two')
    pred = pred && (g.vertex_number == 1)
    assert(pred)
  end

  def test_delete_vertex_and_check_edges_5
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(:one)
    g.delete_vertex!('two')

    pred = !g.has_edge?(0, :one) && !g.has_edge?(:one, 0) && !g.has_edge?(:one, 'two') && !g.has_edge?('two', 'two')
    pred = pred && (g.vertex_number == 1)
    assert(pred)
  end

  def test_delete_vertex_and_check_edges_6
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(0)
    g.delete_vertex!('two')

    pred = !g.has_edge?(0, :one) && !g.has_edge?(:one, 0) && !g.has_edge?('two', 0) && !g.has_edge?(:one, 'two')
    pred = pred && !g.has_edge?('two', 'two') && (g.vertex_number == 1)
    assert(pred)
  end

  def test_delete_vertex_and_check_edges_7
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(0)
    g.delete_vertex!(:one)
    g.delete_vertex!('two')

    pred = !g.has_edge?(0, :one) && !g.has_edge?(:one, 0) && !g.has_edge?('two', 0) && !g.has_edge?(:one, 'two')
    pred = pred && !g.has_edge?('two', 'two') && (g.vertex_number == 0)
    assert(pred)
  end

  def test_delete_edge_1
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_edge!(0, :one)

    pred = !g.has_edge?(0, :one) && (g.edge_number == 4)
    assert(pred)
  end

  def test_delete_edge_2
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_edge!(:one, 0)

    pred = !g.has_edge?(:one, 0) && (g.edge_number == 4)
    assert(pred)
  end

  def test_delete_edge_3
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_edge!(:one, 'two')

    pred = !g.has_edge?(:one, 'two') && (g.edge_number == 4)
    assert(pred)
  end

  def test_delete_edge_4
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_edge!('two', 0)

    pred = !g.has_edge?('two', 0) && (g.edge_number == 4)
    assert(pred)
  end

  def test_delete_edge_5
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_edge!('two', 'two')

    pred = !g.has_edge?('two', 'two') && (g.edge_number == 4)
    assert(pred)
  end

  def test_delete_edge_6
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_edge!(0, :one)
    g.delete_edge!(:one, 0)

    pred = !g.has_edge?(0, :one) && !g.has_edge?(:one, 0) && (g.edge_number == 3)
    assert(pred)
  end

  def test_delete_edge_7
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_edge!(0, :one)
    g.delete_edge!(:one, 'two')

    pred = !g.has_edge?(0, :one) && !g.has_edge?(:one, 'two') && (g.edge_number == 3)
    assert(pred)
  end

  def test_delete_edge_8
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_edge!(0, :one)
    g.delete_edge!('two', 0)

    pred = !g.has_edge?(0, :one) && !g.has_edge?('two', 0) && (g.edge_number == 3)
    assert(pred)
  end

  def test_delete_edge_9
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_edge!(0, :one)
    g.delete_edge!('two', 'two')

    pred = !g.has_edge?(0, :one) && !g.has_edge?('two', 'two') && (g.edge_number == 3)
    assert(pred)
  end

  def test_delete_edge_10
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_edge!(:one, 0)
    g.delete_edge!(:one, 'two')

    pred = !g.has_edge?(:one, 0) && !g.has_edge?(:one, 'two') && (g.edge_number == 3)
    assert(pred)
  end

  def test_delete_edge_11
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_edge!(:one, 0)
    g.delete_edge!('two', 0)

    pred = !g.has_edge?(:one, 0) && !g.has_edge?('two', 0) && (g.edge_number == 3)
    assert(pred)
  end

  def test_delete_edge_12
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_edge!(:one, 0)
    g.delete_edge!('two', 'two')

    pred = !g.has_edge?(:one, 0) && !g.has_edge?('two', 'two') && (g.edge_number == 3)
    assert(pred)
  end

  def test_delete_edge_13
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_edge!(:one, 'two')
    g.delete_edge!('two', 0)

    pred = !g.has_edge?(:one, 'two') && !g.has_edge?('two', 0) && (g.edge_number == 3)
    assert(pred)
  end

  def test_delete_edge_14
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_edge!(:one, 'two')
    g.delete_edge!('two', 'two')

    pred = !g.has_edge?(:one, 'two') && !g.has_edge?('two', 'two') && (g.edge_number == 3)
    assert(pred)
  end

  def test_delete_edge_15
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_edge!('two', 0)
    g.delete_edge!('two', 'two')

    pred = !g.has_edge?('two', 0) && !g.has_edge?('two', 'two') && (g.edge_number == 3)
    assert(pred)
  end

  def test_delete_edge_16
    g = OrientedGraph.new([{v: 0, i: [:one]},
                           {v: :one, i: [0, 'two']},
                           {v: 'two', i: [0, 'two']}])

    g.delete_edge!(0, :one)
    g.delete_edge!(:one, 0)
    g.delete_edge!(:one, 'two')
    g.delete_edge!('two', 0)
    g.delete_edge!('two', 'two')

    pred = !g.has_edge?(0, :one) && !g.has_edge?(:one, 0) && !g.has_edge?(:one, 'two') && !g.has_edge?('two', 0)
    pred = pred && !g.has_edge?('two', 'two') && (g.edge_number == 0)
    assert(pred)
  end

  def test_unoriented_constructor
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: []},
                             {v: 'two', i: []}])

    assert(g.has_edge?(0, :one))
    assert(g.has_edge?(:one, 0))
  end

  def test_unoriented_add_edge
    g = UnorientedGraph.new([{v: 0, i: []},
                             {v: :one, i: []},
                             {v: 'two', i: []}])

    g.add_edge!(0, :one)

    assert(g.has_edge?(0, :one))
    assert(g.has_edge?(:one, 0))
  end

  def test_unoriented_label_edge
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: [0, 'two']},
                             {v: 'two', i: [0, 'two']}])

    g.label_edge!(0, :one, :some_label)
    assert_equal(g.get_edge_label(0, :one), :some_label)
    assert_equal(g.get_edge_label(:one, 0), :some_label)
  end

  def test_delete_unoriented_vertex_with_label
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: ['two']},
                             {v: 'two', i: [0, 'two']}])

    g.label_vertex!(0, :some_label)
    g.delete_vertex!(0)

    pred = !g.has_vertex?(0) && g.vertex_number == 2 && g.vertex_label_number == 0
    assert(pred)
  end

  def test_delete_unoriented_vertex_with_label_with_error
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: ['two']},
                             {v: 'two', i: [0, 'two']}])

    g.label_vertex!(0, :some_label)
    g.delete_vertex!(0)

    exception = assert_raises(GraphError) do
      g.get_vertex_label(0)
    end

    assert_match(/Graph does not contain vertex/, exception.message)
  end

  def test_delete_unoriented_vertex_with_label_and_edge_label
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: [0, 'two']},
                             {v: 'two', i: [0, 'two']}])

    g.label_edge!(0, :one, {'Flex' => :Ricardo_Milos})
    g.label_edge!(:one, 0, 2.82)
    g.label_edge!(:one, 'two', :ьыь)
    g.label_vertex!(:one, 'Эчпочмак')

    g.delete_vertex!(:one)

    pred = !g.has_vertex?(:one) && g.vertex_number == 2 && g.vertex_label_number == 0 && g.edge_label_number == 0
    assert(pred)
  end

  def test_delete_unoriented_edge_with_label
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: [0, 'two']},
                             {v: 'two', i: [0, 'two']}])

    g.label_edge!(0, :one, {'Flex' => :Ricardo_Milos})
    g.label_edge!(:one, 0, 2.82)
    g.label_edge!(:one, 'two', :ьыь)
    g.label_edge!('two', 0, 666)
    g.label_edge!('two', 'two', [19, 17])

    g.delete_edge!(0, :one)
    g.delete_edge!(:one, 0)
    g.delete_edge!(:one, 'two')
    g.delete_edge!('two', 0)
    g.delete_edge!('two', 'two')

    pred = g.edge_number == 0 && g.vertex_number == 3 && g.vertex_label_number == 0 && g.edge_label_number == 0
    pred = pred && !g.has_edge?(0, :one) && !g.has_edge?(:one, 0) && !g.has_edge?(:one, 'two') && !g.has_edge?('two', 0) && !g.has_edge?('two', 'two')
    assert(pred)
  end

  def test_delete_unoriented_vertex_single_1
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: [0, 'two']},
                             {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(0)

    pred = !g.has_vertex?(0) && (g.vertex_number == 2)
    assert(pred)
  end

  def test_delete_unoriented_vertex_single_2
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: [0, 'two']},
                             {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(:one)

    pred = !g.has_vertex?(:one) && (g.vertex_number == 2)
    assert(pred)
  end

  def test_delete_unoriented_vertex_single_3
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: [0, 'two']},
                             {v: 'two', i: [0, 'two']}])

    g.delete_vertex!('two')

    pred = !g.has_vertex?('two') && (g.vertex_number == 2)
    assert(pred)
  end

  def test_delete_unoriented_vertex_single_4
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: [0, 'two']},
                             {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(0)
    g.delete_vertex!(:one)

    pred = !g.has_vertex?(0) && !g.has_vertex?(:one) && (g.vertex_number == 1)
    assert(pred)
  end

  def test_delete_unoriented_vertex_single_5
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: [0, 'two']},
                             {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(0)
    g.delete_vertex!(:one)
    g.delete_vertex!('two')

    pred = !g.has_vertex?(0) && !g.has_vertex?(:one) && !g.has_vertex?('two') && (g.vertex_number == 0)
    assert(pred)
  end

  def test_delete_unoriented_vertex_and_check_edges_1
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: ['two']},
                             {v: 'two', i: [0, 'two']}])
    g.delete_vertex!(0)

    pred = !g.has_edge?(0, :one) && !g.has_edge?(:one, 0) && !g.has_edge?('two', 0) && !g.has_edge?(0, 'two')
    pred = pred && (g.vertex_number == 2)
    assert(pred)
  end

  def test_delete_unoriented_vertex_and_check_edges_2
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: ['two']},
                             {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(0)
    g.delete_vertex!(:one)

    pred = !g.has_edge?(0, :one) && !g.has_edge?(:one, 0) && !g.has_edge?('two', 0) && !g.has_edge?(:one, 'two')
    pred = pred && (g.vertex_number == 1) && !g.has_edge?(0, 'two') && !g.has_edge?('two', :one)
    assert(pred)
  end

  def test_delete_unoriented_vertex_and_check_edges_3
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: ['two']},
                             {v: 'two', i: [0, 'two']}])

    g.delete_vertex!(0)
    g.delete_vertex!('two')

    pred = !g.has_edge?(0, :one) && !g.has_edge?(:one, 0) && !g.has_edge?('two', 0) && !g.has_edge?(:one, 'two')
    pred = pred && !g.has_edge?('two', 'two') && (g.vertex_number == 1) && !g.has_edge?('two', 0) && !g.has_edge?('two', :one)
    assert(pred)
  end

  def test_unoriented_delete_edge_1
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: ['two']},
                             {v: 'two', i: [0, 'two']}])

    g.delete_edge!(0, :one)

    pred = !g.has_edge?(0, :one) && !g.has_edge?(:one, 0) && (g.edge_number == 3)
    assert(pred)
  end

  def test_unoriented_delete_edge_2
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: ['two']},
                             {v: 'two', i: [0, 'two']}])

    g.delete_edge!(:one, 'two')
    g.delete_edge!('two', 'two')

    pred = !g.has_edge?(:one, 'two') && !g.has_edge?(:one, 'two') && !g.has_edge?('two', 'two') && (g.edge_number == 2)
    assert(pred)
  end

  def test_unoriented_delete_edge_3
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: ['two']},
                             {v: 'two', i: [0, 'two']}])

    g.delete_edge!('two', 0)
    g.delete_edge!('two', 'two')

    pred = !g.has_edge?('two', 0) && !g.has_edge?(0, 'two') && !g.has_edge?('two', 'two') && (g.edge_number == 2)
    assert(pred)
  end

  def test_unoriented_delete_edge_4
    g = UnorientedGraph.new([{v: 0, i: [:one]},
                             {v: :one, i: ['two']},
                             {v: 'two', i: [0, 'two']}])

    g.delete_edge!(0, :one)
    g.delete_edge!(:one, 'two')
    g.delete_edge!('two', 0)
    g.delete_edge!('two', 'two')

    pred = !g.has_edge?(0, :one) && !g.has_edge?(:one, 0) && !g.has_edge?(:one, 'two') && !g.has_edge?('two', :one)
    pred = pred && !g.has_edge?('two', 'two') && (g.edge_number == 0) && !g.has_edge?('two', 0) && !g.has_edge?(0, 'two')
    assert(pred)
  end



  def test_dijkstra_1
    g = UnorientedGraph.new([{v: 1, i: [2, 3, 6]},
                             {v: 2, i: [3, 4]},
                             {v: 3, i: [6, 4]},
                             {v: 4, i: [5]},
                             {v: 6, i: [5]}
                            ])
    g.label_edge!(1, 2, 7)
    g.label_edge!(1, 3, 9)
    g.label_edge!(1, 6, 14)
    g.label_edge!(2, 3, 10)
    g.label_edge!(2, 4, 15)
    g.label_edge!(3, 6, 2)
    g.label_edge!(3, 4, 11)
    g.label_edge!(4, 5, 6)
    g.label_edge!(6, 5, 9)
    dijkstra=dijkstra_algorithm(g, 1)
    assert_equal dijkstra["labels"] , {1 => 0, 2 => 7, 3 => 9, 6 => 11, 4 => 20, 5 => 20}
    paths=dijkstra['paths']
    assert_equal paths[1],[1]
    assert_equal paths[2],[1,2]
    assert_equal paths[3],[1,3]
    assert_equal paths[4],[1,3,4]
    assert_equal paths[5],[1,3,6,5]
    assert_equal paths[6],[1,3,6]
  end

  def test_dijkstra_2
    g = OrientedGraph.new([{v: 1, i: [2, 3, 4, 5]},
                           {v: 4, i: [2, 3]},
                           {v: 5, i: [1, 3, 4]},
                          ])
    g.label_edge!(1, 2, 10)
    g.label_edge!(1, 3, 30)
    g.label_edge!(1, 4, 50)
    g.label_edge!(1, 5, 10)
    g.label_edge!(4, 2, 40)
    g.label_edge!(4, 3, 20)
    g.label_edge!(5, 1, 10)
    g.label_edge!(5, 3, 10)
    g.label_edge!(5, 4, 30)
    dijkstra=dijkstra_algorithm(g, 1)
    assert_equal dijkstra["labels"] , {1 => 0, 2 => 10, 3 => 20, 4 => 40, 5 => 10}
    paths=dijkstra['paths']
    assert_equal paths[1],[1]
    assert_equal paths[2],[1,2]
    assert_equal paths[3],[1,5,3]
    assert_equal paths[4],[1,5,4]
    assert_equal paths[5],[1,5]
  end

  def test_dijkstra_3
    g = UnorientedGraph.new([{v: 1, i: [2, 3]},
                             {v: 2, i: [3]},
                             {v: 3, i: [4, 5, 6]},
                             {v: 4, i: [5]},
                             {v: 5, i: [6]}
                            ])
    g.label_edge!(1, 2, 4)
    g.label_edge!(1, 3, 4)
    g.label_edge!(2, 3, 2)
    g.label_edge!(3, 4, 3)
    g.label_edge!(3, 5, 6)
    g.label_edge!(3, 6, 1)
    g.label_edge!(4, 5, 2)
    g.label_edge!(5, 6, 3)
    dijkstra=dijkstra_algorithm(g, 1)
    assert_equal dijkstra["labels"] ,{1 => 0, 2 => 4, 3 => 4, 6 => 5, 4 => 7, 5 => 8}
    paths=dijkstra['paths']
    assert_equal paths[1],[1]
    assert_equal paths[2],[1,2]
    assert_equal paths[3],[1,3]
    assert_equal paths[4],[1,3,4]
    assert_equal paths[5],[1,3,6,5]
    assert_equal paths[6],[1,3,6]
  end

  def test_dijkstra_err
    g = UnorientedGraph.new([{v: 1, i: [2, 3]},
                             {v: 2, i: [3]},
                             {v: 3, i: [4, 5, 6]},
                             {v: 4, i: [5]},
                             {v: 5, i: [6]}
                            ])
    g.label_edge!(1, 2, 4)
    g.label_edge!(1, 3, 4)
    g.label_edge!(2, 3, 2)
    g.label_edge!(3, 4, 3)
    g.label_edge!(3, 5, 6)
    g.label_edge!(3, 6, 1)
    g.label_edge!(4, 5, 2)
    g.label_edge!(5, 6, 3)

    assert_raises "Graph does not contains vertex 7" do
      dijkstra_algorithm(g, 7)
    end
  end


end
