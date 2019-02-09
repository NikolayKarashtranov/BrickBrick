class Brick < VisualGameObject
  attr_reader :hp
  def initialize(x, y, image)
    super(x, y, SizeValues::BRICK_WIDTH, SizeValues::BRICK_HEIGHT, image)
  end

  def get_hit(level)
    @hp -= 1
    if @hp == 1
      @image = Gosu::Image.new("media/brick.png")
    end
    if @hp.zero?
      if rand(8) == 0
        spawn_bonus(level)
      end
      level.bricks.delete(self)
    end
  end

  def spawn_bonus(level)
    bonus_x = left + (@width - SizeValues::BONUS_WIDTH) / 2
    bonus_y = up + (@height - SizeValues::BONUS_HEIGHT) / 2
    klass = [BonusDouble, BonusFire, BonusLength, FakeBall].sample
    double_bonus = klass.new(bonus_x, bonus_y)
    level.bonuses.push(double_bonus)
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
