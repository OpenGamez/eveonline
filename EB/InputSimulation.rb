require "au3" # See http://auto.rubyforge.org/au3/doc/index.html

class InputSimulation
  def self.SimulateMouseClick(x,y, button)
    AutoItX3.move_mouse(x/SCALE_FACTOR, y/SCALE_FACTOR)
    AutoItX3.mouse_click(x/SCALE_FACTOR, y/SCALE_FACTOR, button)
  end
end