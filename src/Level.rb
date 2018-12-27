class Level
  include SizeValues
  attr_accessor :bricks, :bonuses, :next, :balls

  def initialize
    @bricks = Array.new
    @bonuses = Array.new
    @balls = Array.new
    @balls.push Ball.new
  end

  def update_bonuses
    @bonuses = @bonuses.reject do |bonus|
      bonus.up > screen_height
    end
  end

  def move_bonuses
    @bonuses.each{ |bonus| bonus.move }
  end

  def update_balls
    @balls = @balls.reject do |ball|
      ball.up > screen_height
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
    count_of_bricks = 30
    (0..count_of_bricks-1).each do |brick_number|
      row = brick_number/bricks_per_row
      column = brick_number%bricks_per_row
      brick_x = column*brick_width
      brick_y = initial_top_screen_offset + row*brick_height
      brick = SingleHitBrick.new(brick_x, brick_y)
      @bricks.push brick
    end
  end
end

class LevelTwo < Level
  def initialize
    super
    @next = 3
    count_of_bricks = 50
    initial_top_screen_offset = 30
    bricks_per_row = 10
    (0..count_of_bricks-1).each do |brick_number|
      row = brick_number/bricks_per_row
      column = brick_number%bricks_per_row
      brick_x = column*brick_width
      brick_y = initial_top_screen_offset + row*brick_height
      if (row.odd?)
        brick = DoubleHitBrick.new(brick_x, brick_y)
      else
        brick = SingleHitBrick.new(brick_x, brick_y)
      end
      @bricks.push brick
    end
  end
end

class LevelThree < Level
  def initialize
    super
    @next = 4
    count_of_bricks = 55
    initial_top_screen_offset = 30
    max_bricks_on_row = 10
    (0..count_of_bricks-1).each do |brick_number|
      case brick_number
        when 0..9
          brick_x = (brick_number%max_bricks_on_row)*brick_width
          brick_y =initial_top_screen_offset
        when 10..18
          brick_x = (brick_number%max_bricks_on_row + 0.5)*brick_width
          brick_y = initial_top_screen_offset + brick_height
        when 19..26
          brick_x = ((brick_number+1)%max_bricks_on_row + 1)*brick_width
          brick_y = initial_top_screen_offset + brick_height*2
        when 27..33
          brick_x = ((brick_number+3)%max_bricks_on_row + 1.5)*brick_width
          brick_y = initial_top_screen_offset + brick_height*3
        when 34..39
          brick_x = ((brick_number+6)%max_bricks_on_row + 2)*brick_width
          brick_y = initial_top_screen_offset + brick_height*4
        when 40..44
          brick_x = ((brick_number)%max_bricks_on_row + 2.5)*brick_width
          brick_y = initial_top_screen_offset + brick_height*5
        when 45..48
          brick_x =((brick_number+5)%max_bricks_on_row + 3)*brick_width
          brick_y = initial_top_screen_offset + brick_height*6
        when 49..51
          brick_x = ((brick_number+1)%max_bricks_on_row + 3.5)*brick_width
          brick_y = initial_top_screen_offset + brick_height*7
        when 52..53
          brick_x = ((brick_number-2)%max_bricks_on_row + 4)*brick_width
          brick_y = initial_top_screen_offset + brick_height*8
        when 54
          brick_x = 4.5*brick_width
          brick_y = initial_top_screen_offset + brick_height*9
      end
      brick = DoubleHitBrick.new(brick_x, brick_y)
      @bricks.push brick
    end
  end
end