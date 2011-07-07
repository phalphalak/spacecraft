require 'java'

java_import java.lang.Runnable
java_import java.lang.Thread

module SpaceCraft::Controller

  class Tick 
    include Runnable
    attr_accessor :painter, :planet

    def run
      turn_even = true
      while true do
        #Thread.sleep 1500
       
puts '---------------'
p planet.grid[4,6]
p planet.grid[5,6]
 
        calc_water(turn_even)

        turn_even = !turn_even
        painter.paint
      end
    end

    COMPRESS = 0.1
    
    def max_mass_below(mass, mass_below)
      sum = mass + mass_below
      return 1 unless sum > 2
      sum * (1+COMPRESS) / (2+COMPRESS)
    end

    def to_water(block)
      return if block.kind == :water
      if block.kind == :air
        block.kind = :water
        block.mass = 0
      else
        raise "cannot turn #{block.kind} to water (block = #{block.inspect})"
      end
    end

    def handle_block_below(current, neighbour, remaining_mass, turn)
      return remaining_mass if neighbour.kind == :solid
      neighbour_mass = neighbour.mass || 0
      mmb = max_mass_below(current.mass, neighbour_mass)
      if mmb > neighbour_mass
        flow = [mmb - neighbour_mass, remaining_mass].min
        if flow > 0
          transfer_flow(current, neighbour, flow, turn)
          remaining_mass -= flow
        end
      end
      remaining_mass
    end

    def desired_side_flow(current, neighbour, remaining_mass, turn)
      return 0 if neighbour.nil? || neighbour.kind == :solid
      [[(remaining_mass - ((neighbour.kind == :water && neighbour.mass) || 0))/2.0,1].min,0].max
    end

    def handle_side_blocks(current, left, right, remaining_mass, turn)
      left_flow = desired_side_flow(current, left, remaining_mass, turn)
      right_flow = desired_side_flow(current, right, remaining_mass, turn)
      sum = left_flow + right_flow
      if sum > remaining_mass
        left_flow  = left_flow  / sum * remaining_mass
        right_flow = right_flow / sum * remaining_mass
      end
      transfer_flow(current, left,  left_flow,  turn) if left_flow  > 0
      transfer_flow(current, right, right_flow, turn) if right_flow > 0
      sum = left_flow + right_flow
      remaining_mass - sum
    end

    def update_turn(block, turn)
      if block.turn != turn
        block.turn = turn
        block.mass = block.new_mass || block.mass
        block.new_mass = block.mass
        if block.mass < 0
          p block
          #raise "negative mass"
        end
      end
    end

    def to_air(block)
      block.kind = :air
      block.turn = nil
      block.mass = nil
      block.new_mass = nil
    end

    def transfer_flow(source, target, flow, turn)
      to_water(target) if target.kind == :air
      update_turn(target,turn)
      target.new_mass += flow
      source.new_mass -= flow
      if source.new_mass < 0
        p source
        p target
        p flow
        #raise '!'        
      end
    end

    def calc_water(turn)
      puts "turn #{turn}"
      planet.grid.width.times do |x|
        planet.grid.height.times do |y|
          block = planet.grid[x,y]
          next if block.nil?
          if block.kind == :water
#puts "(#{x}, #{y})"
            update_turn(block, turn)
            remaining_mass = block.mass

            unless block.new_mass > 0
              to_air(block)
              next
            end

            if y < planet.grid.height-1
              remaining_mass = handle_block_below(block, planet.grid[x,y+1], remaining_mass, turn)        
            end

            next unless remaining_mass > 0

            left  = x > 0 ? planet.grid[x-1,y] : nil
            right = x < planet.grid.width-1 ? planet.grid[x+1,y] : nil
            remaining_mass = handle_side_blocks(block, left, right, remaining_mass, turn)        
          end
        end
      end

      planet.grid.width.times do |x|
        planet.grid.height.times do |y|
          block = planet.grid[x,y]
          block.mass = block.new_mass
        end
      end
    end

  end
end
