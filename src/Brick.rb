class Brick < VisualGameObject
  include SizeValues
  attr_reader :hp
  def initialize(x, y, image)
    super(x, y, brick_width, brick_height, image)
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
    brick = Gosu::Image.new("media/brick.png")
    super(x, y, brick)
    @hp = 1
  end
end

class DoubleHitBrick < Brick
  def initialize(x, y)
    brick = Gosu::Image.new("media/brick_double.png")
    super(x, y, brick)
    @hp = 2
  end
end