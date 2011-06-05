require 'java'

java_import java.lang.Runnable
java_import java.lang.Thread

module SpaceCraft::Controller

  class Tick 
    include Runnable
    attr_accessor :painter

    def run
      while true do
        Thread.sleep 10
        
        painter.paint
      end
    end

  end
end
