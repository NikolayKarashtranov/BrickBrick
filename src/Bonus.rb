class BonusDouble
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
    @bonus_pic = Gosu::Image.new("media/double.png")
  end

  def move
    @y += Gosu.offset_y(180, 2)
  end

  def activate(level)
    new_balls = Array.new
    level.balls.each do |ball|
      new_balls.push Ball.new(ball.x, ball.y, ball.angle + 30)
    end
    level.balls.concat new_balls
  end

  def draw
    @bonus_pic.draw @x, @y, 0
  end
end