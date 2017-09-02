require 'gosu'
include Math
class Player
  attr_reader :x, :y

  def initialize
    @player = Gosu::Image.new("media/stick.png")
    @x = 300
    @y = 420
  end

  def draw
    @player.draw @x, @y, 0
  end

  def go_left
    if @x > 5
      @x -= 5
    else
      @x = 0
    end
  end

  def go_right
    if @x < 569
      @x += 5
    else
      @x = 574
    end
  end

  def contact_bonuses(level)
    level.bonuses = level.bonuses.reject do |bonus|
      if(bonus.y + 12 > @y && bonus.y < @y + 13 && bonus.x + 25 > @x && bonus.x < @x + 66)
        bonus.activate level 
        true        
      else
        false
      end 
    end    
  end
end

class Ball
  attr_accessor :x, :y, :angle
  def initialize(x = 320, y = 240, angle = 180)
    @ball = Gosu::Image.new("media/ball.png")
    @x = x
    @y = y
    @angle = angle
  end

  def move
    @x += Gosu.offset_x(@angle, 5)
    @y += Gosu.offset_y(@angle, 5)
  end

  def contact_player(player)
    if @x > player.x - 15 && @x < player.x + 66 && @y + 15 <= player.y + 5 && @y + 15 >= player.y
      ball_horizontal_center = @x + 7.5
      player_horizontal_center = player.x + 33
      @angle = ((ball_horizontal_center - player_horizontal_center)*(85/40.5)) % 360
    end
  end

  def contact_walls
    if @x <= 0 || @x >= 625
      @angle = (360 - @angle)
    end
    if @y <= 0
      @angle = (180 - @angle) % 360
    end
  end

  def contact_bricks(level)
    angle_in_radians = @angle/180 * PI
    have_a_horizontal_hit = false
    have_a_vertical_hit = false    
    
    level.bricks = level.bricks.reject do |brick|
      already_hit = brick_destroyed = false 

      is_ball_in_brick_horizontal_range = @x > brick.x - 15 && @x < brick.x + 64
      is_ball_in_contact_down_wall = @y >= brick.y + 11 && @y < brick.y + 16
      is_ball_in_contact_up_wall = @y + 15 > brick.y && @y + 15 <= brick.y + 5
      is_ball_coming_from_below = cos(angle_in_radians) > 0      
      is_ball_coming_from_above = cos(angle_in_radians) < 0

      is_ball_in_brick_vertical_range = @y + 15 > brick.y && @y < brick.y + 16
      is_ball_in_contact_left_wall = @x > brick.x - 15 && @x <= brick.x - 10
      is_ball_in_contact_right_wall = @x >= brick.x + 59 && @x < brick.x + 64
      is_ball_coming_from_left = sin(angle_in_radians) > 0
      is_ball_coming_from_right = sin(angle_in_radians) < 0

      if (!have_a_vertical_hit && is_ball_in_brick_horizontal_range)
        if (is_ball_in_contact_down_wall && is_ball_coming_from_below) || (is_ball_in_contact_up_wall && is_ball_coming_from_above)
          @angle = (180 - @angle) % 360
          brick.get_hit
          already_hit = true
          have_a_vertical_hit = true
          if (brick.hp == 0)
            if(rand(8) == 0)
              double_bonus = BonusDouble.new(brick.x + 20, brick.y + 16)              
              level.bonuses.push(double_bonus)              
            end
            brick_destroyed = true
          end
        end
      end
      if (!have_a_horizontal_hit && !already_hit && is_ball_in_brick_vertical_range)
        if (is_ball_in_contact_left_wall && is_ball_coming_from_left) || (is_ball_in_contact_right_wall && is_ball_coming_from_right)
          @angle = (360 - @angle) % 360          
          brick.get_hit          
          have_a_horizontal_hit = true
          if(brick.hp == 0)
            if(rand(8) == 0)
              double_bonus = BonusDouble.new(brick.x + 20, brick.y + 16)              
              level.bonuses.push(double_bonus)              
            end
            brick_destroyed = true
          end
        end        
      end
      brick_destroyed
    end    
  end

  def draw
    self.move
    @ball.draw @x, @y, 0
  end
end

class Brick
  attr_reader :x, :y, :hp

  def draw
    @brick.draw @x, @y, 0
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
    @brick = Gosu::Image.new("media/brick.png")
    @x = x
    @y = y
    @hp = 1
  end
end

class DoubleHitBrick < Brick
  def initialize(x, y)
    @brick = Gosu::Image.new("media/brick_double.png")
    @x = x
    @y = y
    @hp = 2
  end
end

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
    @balls.each{ |ball| ball.draw }
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

module Victory
  def self.initialize
    @@victory = Gosu::Image.new("media/YouWon.png")
  end

  def self.draw
    @@victory.draw 155, 188, 0
  end
end

module GameOver
  def self.initialize
    @@game_over = Gosu::Image.new("media/GameOver.png")
  end

  def self.draw
    @@game_over.draw 158, 188, 0
  end
end

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

class BrickBrick < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "BrickBrick"    
    @player = Player.new
    GameOver.initialize
    Victory.initialize
    @level = LevelOne.new
    
    @game_over = @win = false
  end

  def update
    if Gosu.button_down? Gosu::KB_LEFT
      @player.go_left
    end

    if Gosu.button_down? Gosu::KB_RIGHT
      @player.go_right
    end

    if @game_over || @win
      if Gosu.button_down? Gosu::KB_SPACE
        initialize
      end
    end

    @level.update_bonuses()
    @level.move_bonuses()
    @level.update_balls()
    @level.balls.each do |ball|
      ball.contact_player(@player)
      ball.contact_walls
      ball.contact_bricks(@level)
    end
    @player.contact_bonuses(@level)
    if(@level.over?)
      case @level.next
      when 2
        @level = LevelTwo.new
      when 3
        @level = LevelThree.new
      when 4
        @win = true
      end
    end
    @game_over = @level.balls.empty?
  end

  def draw
    if !@game_over && !@win
      @player.draw
      @level.draw  
    elsif @win
      Victory.draw
    else
      GameOver.draw
    end
  end
end

BrickBrick.new.show