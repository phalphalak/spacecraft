require 'java'

class SpaceCraft::Controller::Planet
  include Listener

  attr_accessor :view, :model

  def mouse_wheel_moved(e)
    @view.zoom += e.wheel_rotation
    puts @view.zoom
  end

end
