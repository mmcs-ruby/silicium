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

    assert(ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_file(filename.sub('tmp', 'test/resources')))
               .eql?(ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_file(filename))))
  end

  def test_plotter_bar_chart_1st_quadrant
    filename = 'tmp/bar_chart_1st_quadrant.png'
    File.delete(filename) if File.exist?(filename)

    plotter = Image.new(200, 100)
    plotter.bar_chart({ 20 => 10, 40 => 20, 80 => 40, 160 => 80 }, 1, ChunkyPNG::Color('red @ 1.0'))
    plotter.export(filename)

    assert(ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_file(filename.sub('tmp', 'test/resources')))
               .eql?(ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_file(filename))))
  end

  def test_plotter_bar_chart_2nd_quadrant
    filename = 'tmp/bar_chart_2nd_quadrant.png'
    File.delete(filename) if File.exist?(filename)

    plotter = Image.new(200, 100)
    plotter.bar_chart({ -20 => 10, -40 => 20, -80 => 40, -160 => 80 }, 1, ChunkyPNG::Color('red @ 1.0'))
    plotter.export(filename)

    assert(ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_file(filename.sub('tmp', 'test/resources')))
               .eql?(ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_file(filename))))
  end

  def test_plotter_bar_chart_3rd_quadrant
    filename = 'tmp/bar_chart_3rd_quadrant.png'
    File.delete(filename) if File.exist?(filename)

    plotter = Image.new(200, 100)
    plotter.bar_chart({ -20 => -10, -40 => -20, -80 => -40, -160 => -80 }, 1, ChunkyPNG::Color('red @ 1.0'))
    plotter.export(filename)

    assert(ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_file(filename.sub('tmp', 'test/resources')))
               .eql?(ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_file(filename))))
  end

  def test_plotter_bar_chart_4th_quadrant
    filename = 'tmp/bar_chart_4th_quadrant.png'
    File.delete(filename) if File.exist?(filename)

    plotter = Image.new(200, 100)
    plotter.bar_chart({ 20 => -10, 40 => -20, 80 => -40, 160 => -80 }, 1, ChunkyPNG::Color('red @ 1.0'))
    plotter.export(filename)

    assert(ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_file(filename.sub('tmp', 'test/resources')))
               .eql?(ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_file(filename))))
  end

  def test_plotter_bar_chart_1st2nd_quadrant
    filename = 'tmp/bar_chart_1st2nd_quadrant.png'
    File.delete(filename) if File.exist?(filename)

    plotter = Image.new(200, 100)
    plotter.bar_chart({ -20 => 10, -40 => 20, -80 => 40, -160 => 80,
                        20 => 10, 40 => 20, 80 => 40, 160 => 80 }, 1, ChunkyPNG::Color('red @ 1.0'))
    plotter.export(filename)

    assert(ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_file(filename.sub('tmp', 'test/resources')))
               .eql?(ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_file(filename))))
  end

  def test_plotter_bar_chart_3rd4th_quadrant
    filename = 'tmp/bar_chart_3rd4th_quadrant.png'
    File.delete(filename) if File.exist?(filename)

    plotter = Image.new(200, 100)
    plotter.bar_chart({ -20 => -10, -40 => -20, -80 => -40, -160 => -80,
                        20 => -10, 40 => -20, 80 => -40, 160 => -80 }, 1, ChunkyPNG::Color('red @ 1.0'))
    plotter.export(filename)

    assert(ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_file(filename.sub('tmp', 'test/resources')))
               .eql?(ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_file(filename))))
  end

  def test_plotter_bar_chart_all_quadrant
    filename = 'tmp/bar_chart_all_quadrant.png'
    File.delete(filename) if File.exist?(filename)

    plotter = Image.new(200, 100)
    plotter.bar_chart({ 20 => -10, -40 => -20, -80 => 40, 160 => 80 }, 1, ChunkyPNG::Color('red @ 1.0'))
    plotter.export(filename)

    assert(ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_file(filename.sub('tmp', 'test/resources')))
               .eql?(ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_file(filename))))
  end

end