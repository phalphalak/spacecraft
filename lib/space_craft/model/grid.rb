class SpaceCraft::Model::Grid

  attr_accessor :data

  def initialize(width, height)
    self.data = Array.new(width) { Array.new(height) }
  end

  def [](x,y)
    validate_include(x,y)
    self.data[x][y]
  end

  def []=(x,y,value)
    validate_include(x,y)
    self.data[x][y] = value
  end

  def width
    self.data.length
  end

  def height
    self.data.first.length
  end

  def validate_include(x,y)
    raise "x or y out of range (x=#{x}m y=#{y} )" unless self.include?(x,y)
  end

  def include?(x,y)
    (0..width-1).include?(x) && (0..height-1).include?(y)
  end
  
end
