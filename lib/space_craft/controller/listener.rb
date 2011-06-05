require 'java'

java_import java.awt.event.ComponentListener
java_import java.awt.event.MouseWheelListener
java_import javax.swing.event.MouseInputListener  

module Listener
  include ComponentListener
  include MouseInputListener
  include MouseWheelListener

  def component_resized(e)
  end 

  def mouse_entered(e)
  end 

  def mouse_exited(e)
  end 

  def mouse_moved(e)
  end

def mouse_dragged(e)
  end

  def mouse_pressed(e)
  end

  def mouse_released(e)
  end

  def mouse_clicked(e)
  end

  def mouse_wheel_moved(e)
  end

end
