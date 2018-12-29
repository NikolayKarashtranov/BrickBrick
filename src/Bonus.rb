class BonusDouble < VisualGameObject
  attr_accessor :x, :y
  def initialize(x, y)
    bonus_pic = Gosu::Image.new("media/double.png")
    super(x, y, SizeValues::BONUS_WIDTH, SizeValues::BONUS_HEIGHT, bonus_pic)
  end

  def move
    @y += SizeValues::BONUS_STEP
  end

  def activate(level)
    new_balls = Array.new
    level.balls.each do |ball|
      new_balls.push Ball.new(ball.x, ball.y, rand(360))
    end
    level.balls.concat new_balls
  end
end