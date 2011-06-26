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

    def grid_size
      16
    end

    def paint
      width = view.width
      height = view.height
      return if width == 0 || height == 0
      
      image = BufferedImage.new(width, height, BufferedImage::TYPE_INT_RGB)
      g = image.create_graphics

      g.color = Color::GRAY
      g.fill_rect(0, 0, width, height)

      grid = planet.grid

      g.color = Color::BLACK
      g.fill_rect(0, 0, grid.width * grid_size, grid.height * grid_size)

      grid.width.times do |x|
        grid.height.times do |y|
          paint_block(g,x,y)
        end
      end

      g.color = Color::WHITE
      g.draw_string("#{fps.to_i.to_s} fps", 10, 20)
      view.schedule_image(image)
    end

    def remap(v, source_from, source_to, target_from, target_to)
      delta_source = source_to - source_from
      delta_target = target_to - target_from
      (v - source_from ) * delta_target / delta_source + target_from
    end

    def water_color(mass)
      min = 0
      max = 1.1
      value = [[mass,min].max, max].min
   
      b = 255
      #rg = remap(value, min, max, 200, 50)  
      rg = remap(value, min, max, 40, 100)  
=begin 
      rg = 50
      b = nil

      if mass < 1
        b  = remap(value, min, 1, 255, 200).to_i
        rg = remap(value, min, 1, 240, 50).to_i
        rg = [[rg, 50].max, 240].min
      else
        b  = remap(value, 1, max, 190, 140).to_i
      end
      b = [[rg, 140].max, 255].min
=end
      Color.new(rg, rg, b)
    end

    def paint_block(g, x, y)
      block = planet.grid[x,y]
      if block
        x_offset = x * grid_size
        y_offset = y * grid_size

        if block.kind == :water
          #g.color = Color::BLUE
          height = [block.mass, 1.0].min * grid_size

#          if y > 0 && planet.grid[x,y-1].kind == :water
#            g.color = water_color(planet.grid[x,y-1].mass)
#            g.fill_rect x_offset, y_offset, grid_size, grid_size
#          end

          g.color = water_color(block.mass)
          g.fill_rect x_offset, y_offset+(grid_size-height), grid_size, height
          #g.color = Color.new 128,128,255
          #g.draw_rect x_offset, y_offset+(grid_size-height), grid_size, height
        elsif block.kind == :solid
          g.color = Color.new 0,64,0
          g.fill_rect x_offset, y_offset, grid_size, grid_size
          g.color = Color::GREEN
          g.draw_rect x_offset, y_offset, grid_size, grid_size
        end
      end
    end

  end
end
