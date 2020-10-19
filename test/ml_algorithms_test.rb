require 'test_helper'
require 'silicium_test'
require 'ml_algorithms'
class MLAlgorithmsTest < SiliciumTest
  include BackPropogation
  def test_computational_graph_string_parse_norm
    assert_equal(ComputationalGraph.PolishParser("(x * W1 + b1) * W2 + b2", []), 'x W1 * b1 + W2 * b2 + ')
  end

  def test_computational_graph_string_parse_empty
    assert_equal(ComputationalGraph.PolishParser("", []), '')
  end

  def test_computational_graph_string_parse_wrong_brackets
    assert_raises(ArgumentError){ComputationalGraph.PolishParser("(x*W1+b1)*W2+)b2", [])}
    assert_raises(ArgumentError){ComputationalGraph.PolishParser("(x*(W1+b1)*W2+b2", [])}
  end

  def test_computational_graph_forward_pass_trivial
    test_graph = ComputationalGraph.new("(x*W1+b1)/L2*W2+b2")
    variables = Hash["x",1.0,"W1",1.0,"b1",1.0,"W2",1.0,"b2",1.0,"L2",2.0]
    assert_equal(test_graph.ForwardPass(variables),2.0)
  end

  def test_computational_graph_backward_pass_trivial
    test_graph = ComputationalGraph.new("(x*W1+b1)/L2*W2+b2")
    variables = Hash["x",1.0,"W1",1.0,"b1",1.0,"W2",1.0,"b2",1.0,"L2",2.0]
    test_graph.ForwardPass(variables)
    trivial_loss = 1
    assert_equal(test_graph.BackwardPass(trivial_loss),{"b2"=>1, "W2"=>1.0, "L2"=>-0.25, "b1"=>-0.25, "W1"=>-0.25, "x"=>-0.25})
  end

  def test_computational_graph_backward_pass_learning_quality
    learn_rate = 0.01
    variables = Hash["x",2.0,"W1",0.1,"b1",0.001,"W2",0.1,"b2",0.001]
    true_val = variables["x"] * 4
    test_graph = ComputationalGraph.new("(x*W1+b1)*W2+b2")
    for i in 1..300
      dummy_loss = 0.5*(true_val - test_graph.ForwardPass(variables))
      grad = test_graph.BackwardPass(dummy_loss)
      variables["W1"] += grad["W1"]*learn_rate
      variables["W2"] += grad["W2"]*learn_rate
      variables["b1"] += grad["b1"]*learn_rate
      variables["b2"] += grad["b2"]*learn_rate
    end

    res = (test_graph.ForwardPass(variables)-true_val).abs< 0.0001
    assert_equal(res,true)
  end

  end