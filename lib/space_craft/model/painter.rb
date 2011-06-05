require 'java'

java_import java.lang.System
java_import java.awt.image.BufferedImage
java_import java.awt.Color


module SpaceCraft::Model
  class Painter

    attr_accessor :view, :planet

    def initialize
    end

    def fps
      now = System.current_time_millis
      millis = 1000
      @last_mark ||= now
      @counter = (@counter|| 0) + 1
      diff = now - @last_mark
      if diff > millis && @counter > 0
        @current_fps = @counter.to_f / (diff/1000.0)
        @last_mark = now
        @counter = 0
      end
      @current_fps
    end

    def paint
      width = view.width
      height = view.height
      return if width == 0 || height == 0
      
      image = BufferedImage.new(width, height, BufferedImage::TYPE_INT_RGB)
      g = image.create_graphics

      g.color = Color::BLACK
      g.fill_rect(0, 0, width, height)

      grid = planet
      grid.width.times do |x|
        grid.height.times do |y|
          
        end
      end

      g.color = Color::WHITE
      g.draw_string("#{fps.to_i.to_s} fps", 10, 30)
      view.schedule_image(image)
    end
  end
end
