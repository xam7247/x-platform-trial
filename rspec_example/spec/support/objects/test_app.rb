class TestApp

  attr_reader :component_objects

  def initialize
    @component_objects = {}
  end

  def home
    component_objects[:home] ||= Home.new
  end

  def inner_screen
    component_objects[:inner_screen] ||= InnerScreen.new
  end

end