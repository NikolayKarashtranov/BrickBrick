class BonusDouble < VisualGameObject
  include SizeValues
  attr_accessor :x, :y
  def initialize(x, y)
    super(x, y, bonus_width, bonus_height)
    @bonus_pic = Gosu::Image.new("media/double.png")
  end

  def move
    @y += bonus_step
  end

  def activate(level)
    new_balls = Array.new
    level.balls.each do |ball|
      new_balls.push Ball.new(ball.x, ball.y, rand(360))
    end
    level.balls.concat new_balls
  end

  def draw
    @bonus_pic.draw @x, @y, 0
  end
end