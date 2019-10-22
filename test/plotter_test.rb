require "test_helper"
require 'plotter'
require 'chunky_png'

class SiliciumTest < Minitest::Test
  include Silicium::Plotter

  def test_plotter_rectangle
    #todo write method to remove all *.png from tmp before and after running tests
    filename = 'tmp/rectangle.png'
    File.delete(filename) if File.exist?(filename)

    plotter = Image.new(100, 100)
    #todo encapsulate ChunkyPNG::Color into Plotter class
    plotter.rectangle(20, 30, 50, 60, ChunkyPNG::Color('black @ 0.5'))
    plotter.export(filename)
  endg

end