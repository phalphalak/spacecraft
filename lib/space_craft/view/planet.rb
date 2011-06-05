require 'java'

java_import javax.swing.JPanel
java_import java.awt.Color
java_import javax.swing.SwingUtilities

class SpaceCraft::View::Planet < JPanel

  attr_accessor :grid, :offset, :zoom
  attr_reader :controller

  def initialize
    self.offset = [0,0]
    self.zoom = 0
  end

  # TODO concurrency
  def schedule_image(image)
    @image = image
    SwingUtilities.invokeAndWait { repaint }
  end

  def controller=(controller)
    @controller = controller
    self.addComponentListener(controller)
    self.addMouseListener(controller)
    self.addMouseMotionListener(controller)
    self.addMouseWheelListener(controller)
  end

  def paintComponent(g)
    super g
    g.draw_image(@image, 0, 0, self) if @image
=begin
    g.color = Color.black 
    g.fill_rect(0, 0, width, height)

    return unless self.grid

    grid.width.times do |x|
      grid.height.times do |y|
        
      end
    end
=end    
  end 

end
