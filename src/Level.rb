class Level
  attr_accessor :bricks, :bonuses, :next, :balls

  def initialize
    @bricks = Array.new
    @bonuses = Array.new
    @balls = Array.new
    @balls.push Ball.new
  end

  def update_bonuses
    @bonuses = @bonuses.reject do |bonus|
      bonus.y > 480
    end
  end

  def move_bonuses
    @bonuses.each{ |bonus| bonus.move }
  end

  def update_balls
    @balls = @balls.reject do |ball|
      ball.y > 480
    end
  end

  def over?
    @bricks.empty?
  end

  def draw
    @bricks.each{ |brick| brick.draw }
    @bonuses.each{ |bonus| bonus.draw }
    @balls.each do |ball|
      ball.move 
      ball.draw
    end
  end
end

class LevelOne < Level
  def initialize
    super
    @next = 2
    (0..29).each do |brick_number|
      brick = SingleHitBrick.new((brick_number%10)*64, 30 + (brick_number/10)*16)
      @bricks.push brick
    end
  end
end

class LevelTwo < Level
  def initialize
    super
    @next = 3
    (0..49).each do |brick_number|
      if ((brick_number/10)%2 == 1)
        brick = DoubleHitBrick.new((brick_number%10)*64, 30 + (brick_number/10)*16)
      else
        brick = SingleHitBrick.new((brick_number%10)*64, 30 + (brick_number/10)*16)
      end
      @bricks.push brick
    end
  end
end

class LevelThree < Level
  def initialize
    super
    @next = 4
    (0..54).each do |brick_number|     
      case brick_number
        when 0..9 
          brick = DoubleHitBrick.new((brick_number%10)*64, 30)
        when 10..18
          brick = DoubleHitBrick.new((brick_number%10 + 0.5)*64, 46)
        when 19..26
          brick = DoubleHitBrick.new(((brick_number+1)%10 + 1)*64, 62)
        when 27..33
          brick = DoubleHitBrick.new(((brick_number+3)%10 + 1.5)*64, 78)
        when 34..39
          brick = DoubleHitBrick.new(((brick_number+6)%10 + 2)*64, 94)
        when 40..44
          brick = DoubleHitBrick.new(((brick_number)%10 + 2.5)*64, 110)
        when 45..48
          brick = DoubleHitBrick.new(((brick_number+5)%10 + 3)*64, 126)
        when 49..51
          brick = DoubleHitBrick.new(((brick_number+1)%10 + 3.5)*64, 142)
        when 52..53
          brick = DoubleHitBrick.new(((brick_number-2)%10 + 4)*64, 158)
        when 54
          brick = DoubleHitBrick.new(4.5*64, 174)
      end
      @bricks.push brick
    end
  end
end