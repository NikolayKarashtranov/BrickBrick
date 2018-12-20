class Brick
  attr_reader :x, :y, :hp

  def draw
    @brick.draw @x, @y, 0
  end

  def get_hit
    @hp -= 1
    if(@hp == 1)
      @brick = Gosu::Image.new("media/brick.png")
    end
  end
end

class SingleHitBrick < Brick
  def initialize(x, y)
    @brick = Gosu::Image.new("media/brick.png")
    @x = x
    @y = y
    @hp = 1
  end
end

class DoubleHitBrick < Brick
  def initialize(x, y)
    @brick = Gosu::Image.new("media/brick_double.png")
    @x = x
    @y = y
    @hp = 2
  end
end