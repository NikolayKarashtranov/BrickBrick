class Level
  attr_accessor :bricks, :bonuses, :balls, :bullets, :active_bonuses, :fake_ball_effect
  attr_reader :player
  def initialize(player)
    @bricks = Array.new
    @bonuses = Array.new
    @active_bonuses = Array.new
    @balls = Array.new
    @bullets = Array.new
    @balls.push Ball.new
    @player = player
    @fake_ball_effect = false
  end

  def process_updated(state)
    if over?
      state.pause = true
      @player.back_to_start
      case self
      when LevelOne
        state.level = LevelTwo.new(@player)
      when LevelTwo
        state.level = LevelThree.new(@player)
      when LevelThree
        win = true
      end
    end
    if win
      state = Victory.new(state.window)
    elsif balls.empty? || @fake_ball_effect
      state = GameOver.new(state.window)
    end
    state
  end

  def update(state)
    update_bonuses
    move_bonuses
    update_active_bonuses
    update_bullets
    move_bullets
    update_balls(@player)
    move_balls
    @player.contact_bonuses(self)
    process_updated(state)
  end

  def update_bonuses
    @bonuses.reject! do |bonus|
      bonus.up > SizeValues::SCREEN_HEIGHT
    end
  end

  def update_active_bonuses
    @active_bonuses.each{ |bonus| bonus.update(self) }
  end

  def move_bonuses
    @bonuses.each{ |bonus| bonus.move }
  end

  def update_balls(player)
    @balls.reject! do |ball|
      ball.contact_player(player)
      ball.contact_walls
      ball.contact_bricks(self)
      ball.up > SizeValues::SCREEN_HEIGHT
    end
  end

  def update_bullets
    @bullets.reject! do |bullet|
      ind = bullet.contact_bricks(self)
      ind || bullet.down <= 0
    end
  end

  def move_bullets
    @bullets.each{ |bullet| bullet.move }
  end

  def move_balls
    @balls.each do |ball|
      ball.move
    end
  end

  def over?
    @bricks.empty?
  end

  def draw
    @bricks.each{ |brick| brick.draw }
    @bonuses.each{ |bonus| bonus.draw }
    @bullets.each{ |bullet| bullet.draw }
    @balls.each{ |ball| ball.draw }
  end
end

class LevelOne < Level
  def initialize(player)
    super
    count_of_bricks = 30
    bricks_per_row = 10
    initial_top_screen_offset = 30
    (0..count_of_bricks-1).each do |brick_number|
      row = brick_number / bricks_per_row
      column = brick_number % bricks_per_row
      brick_x = column*SizeValues::BRICK_WIDTH
      brick_y = initial_top_screen_offset + row * SizeValues::BRICK_HEIGHT
      brick = SingleHitBrick.new(brick_x, brick_y)
      @bricks.push brick
    end
  end
end

class LevelTwo < Level
  def initialize(player)
    super
    count_of_bricks = 50
    initial_top_screen_offset = 30
    bricks_per_row = 10
    (0..count_of_bricks - 1).each do |brick_number|
      row = brick_number / bricks_per_row
      column = brick_number % bricks_per_row
      brick_x = column * SizeValues::BRICK_WIDTH
      brick_y = initial_top_screen_offset + row * SizeValues::BRICK_HEIGHT
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
  def initialize(player)
    super
    count_of_bricks = 55
    initial_top_screen_offset = 30
    max_bricks_on_row = 10
    brick_width = SizeValues::BRICK_WIDTH
    brick_heigth = SizeValues::BRICK_HEIGHT
    (0..count_of_bricks-1).each do |brick_number|
      case brick_number
        when 0..9
          brick_x = (brick_number % max_bricks_on_row) * brick_width
          brick_y = initial_top_screen_offset
        when 10..18
          brick_x = (brick_number % max_bricks_on_row + 0.5) * brick_width
          brick_y = initial_top_screen_offset + brick_heigth
        when 19..26
          brick_x = ((brick_number + 1) % max_bricks_on_row + 1) * brick_width
          brick_y = initial_top_screen_offset + brick_heigth * 2
        when 27..33
          brick_x = ((brick_number + 3) % max_bricks_on_row + 1.5) * brick_width
          brick_y = initial_top_screen_offset + brick_heigth * 3
        when 34..39
          brick_x = ((brick_number + 6) % max_bricks_on_row + 2) * brick_width
          brick_y = initial_top_screen_offset + brick_heigth * 4
        when 40..44
          brick_x = ((brick_number) % max_bricks_on_row + 2.5) * brick_width
          brick_y = initial_top_screen_offset + brick_heigth * 5
        when 45..48
          brick_x = ((brick_number + 5) % max_bricks_on_row + 3) * brick_width
          brick_y = initial_top_screen_offset + brick_heigth * 6
        when 49..51
          brick_x = ((brick_number + 1) % max_bricks_on_row + 3.5) * brick_width
          brick_y = initial_top_screen_offset + brick_heigth * 7
        when 52..53
          brick_x = ((brick_number - 2) % max_bricks_on_row + 4) * brick_width
          brick_y = initial_top_screen_offset + brick_heigth * 8
        when 54
          brick_x = 4.5 * brick_width
          brick_y = initial_top_screen_offset + brick_heigth * 9
      end
      brick = DoubleHitBrick.new(brick_x, brick_y)
      @bricks.push brick
    end
  end
end
