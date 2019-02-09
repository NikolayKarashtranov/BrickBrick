class GameImage
  attr_accessor :x, :y, :image
  def initialize(x_coord, y_coord, image)
    @x = x_coord
    @y = y_coord
    @image = image
  end

  def draw
    @image.draw(@x, @y, 0)
  end
end

class VisualGameObject < GameImage
  attr_accessor :width, :height
  def initialize(x_coord, y_coord, width, height, image)
    @width = width
    @height = height
    super(x_coord, y_coord, image)
  end

  def left
    @x
  end

  def up
    @y
  end

  def right
    @x + @width
  end

  def down
    @y + @height
  end
end
