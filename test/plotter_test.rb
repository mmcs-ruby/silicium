require "test_helper"
require 'plotter'
require 'chunky_png'

class SiliciumTest < Minitest::Test
  include Silicium::Plotter

  @@dir_ready = File.directory?('tmp') || Dir.mkdir('tmp')

  def test_plotter_rectangle
    #todo write method to remove all *.png from tmp before and after running tests
    filename = 'tmp/rectangle.png'
    File.delete(filename) if File.exist?(filename)

    plotter = Image.new(100, 100)
    #todo encapsulate ChunkyPNG::Color into Plotter class
    plotter.rectangle(20, 30, 50, 60, ChunkyPNG::Color('black @ 0.5'))
    plotter.export(filename)
  end

  def test_plotter_bar_chart
    filename = 'tmp/bar_chart.png'
    File.delete(filename) if File.exist?(filename)

    plotter = Image.new(200, 100)
    plotter.bar_chart({ -200 => 10, 40 => 20, 80 => 40, 160 => 80 }, 4, ChunkyPNG::Color::BLACK)
    plotter.export(filename)

  end

end