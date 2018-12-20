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