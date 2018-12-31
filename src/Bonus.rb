class Bonus < VisualGameObject
  attr_accessor :active
  def initialize(x, y, bonus_pic)
    @active = false
    super(x, y, SizeValues::BONUS_WIDTH, SizeValues::BONUS_HEIGHT, bonus_pic)
  end

  def move
    @y += SizeValues::BONUS_STEP
  end
end


class BonusDouble < Bonus
  attr_accessor :x, :y
  def initialize(x, y)
    bonus_pic = Gosu::Image.new("media/double.png")
    super(x, y, bonus_pic)
  end

  def activate(level)
    new_balls = Array.new
    level.balls.each do |ball|
      new_balls.push Ball.new(ball.x, ball.y, rand(360))
    end
    level.balls.concat new_balls
  end
end

class BonusFire < Bonus
  attr_accessor :previous_shoot
  attr_reader :number_of_shots
  def initialize(x, y, shots = false)
    bonus_pic = Gosu::Image.new("media/fire.png")
    @number_of_shots = shots ? shots : SizeValues::NUMBER_OF_SHOTS
    @shoot_period = SizeValues::PERIOD_OF_SHOOTS
    @previous_shoot = false
    super(x, y, bonus_pic)
  end

  def fire(level)
    @previous_shoot = Gosu.milliseconds
    @number_of_shots -= 1
    left_bullet_x = level.player.left
    right_bullet_x = level.player.right - SizeValues::BULLET_WIDTH
    bullet_y = level.player.up - SizeValues::BULLET_HEIGHT
    left_bullet = Bullet.new(left_bullet_x, bullet_y)
    right_bullet = Bullet.new(right_bullet_x, bullet_y)
    level.bullets.push(left_bullet).push(right_bullet)
  end

  def update(level)
    if @number_of_shots == 0
      level.active_bonuses.delete(self)
    elsif !@previous_shoot
      fire(level)
    elsif Gosu::milliseconds - @shoot_period > @previous_shoot
      fire(level)
    end
    
  end

  def activate(level)
    level.active_bonuses.push(self)
  end
end

class BonusLength < Bonus
  def initialize(x, y)
    bonus_pic = Gosu::Image.new("media/length.png")
    @period = SizeValues::FIRE_BONUS_TIME
    super(x, y, bonus_pic)
  end

  def activate(level)
    level.player.switch_length
  end
end

class FakeBall < VisualGameObject
  def initialize(x, y)
    ball = Gosu::Image.new("media/ball.png")
    super(x, y, SizeValues::BALL_DIAMETER, SizeValues::BALL_DIAMETER, ball)
  end

  def move
    @y += SizeValues::BALL_STEP
  end

  def activate(level)
    level.fake_ball_effect = true
  end
end

class Bullet < VisualGameObject
  def initialize(x, y)
    bullet_pic = Gosu::Image.new("media/bullet.png")
    @step = SizeValues::BULLET_STEP
    super(x, y, SizeValues::BULLET_WIDTH, SizeValues::BULLET_HEIGHT, bullet_pic)
  end

  def move
    @y -= @step
  end

  def contact_bricks(level)
    level.bricks.index do |brick|
      in_horizontal_range = right >= brick.left && left <= brick.right
      in_vertical_range = up >= brick.down && up <= brick.down + @step
      if in_horizontal_range && in_vertical_range
        brick.get_hit(level)
        true
      else
        false
      end
    end
  end
end