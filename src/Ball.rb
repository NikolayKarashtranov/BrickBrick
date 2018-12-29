class Ball < VisualGameObject
  attr_accessor :angle
  def initialize(x = SizeValues::CENTER_X, y = SizeValues::CENTER_Y, angle = 180)
    ball = Gosu::Image.new("media/ball.png")
    super(x, y, SizeValues::BALL_DIAMETER, SizeValues::BALL_DIAMETER, ball)
    @angle = angle
  end

  def move
    @x += Gosu.offset_x(@angle, SizeValues::BALL_STEP)
    @y += Gosu.offset_y(@angle, SizeValues::BALL_STEP)
  end

  def calc_ball_player_contact_angle(player)
    half_width = width/2.0
    player_half_width = player.width/2.0
    ball_horizontal_center = left + half_width
    player_horizontal_center = player.left + player_half_width
    angle_coef = SizeValues::ANGLE_FORMULA_MAX_ANGLE / (half_width + player_half_width)
    ((ball_horizontal_center - player_horizontal_center)*angle_coef) % 360
  end

  def contact_player(player)
    if right > player.left && left < player.right && down <= player.up + SizeValues::CONTACT_BUFFER && down >= player.up
      @angle = calc_ball_player_contact_angle(player)
    end
  end

  def contact_walls
    if @x <= 0 || @x >= SizeValues::SCREEN_WIDTH - @width
      @angle = (360 - @angle)
    end
    if @y <= 0
      @angle = (180 - @angle) % 360
    end
  end

  def vertical_wall_brick_hit(brick)
    angle_in_radians = @angle/180 * PI
    is_ball_in_brick_horizontal_range = right > brick.left && left < brick.right
    if is_ball_in_brick_horizontal_range
      is_ball_in_contact_down_wall = up < brick.down && up >= brick.down - SizeValues::CONTACT_BUFFER
      is_ball_in_contact_up_wall = down > brick.up && down <= brick.up + SizeValues::CONTACT_BUFFER
      is_ball_coming_from_below = cos(angle_in_radians) > 0
      is_ball_coming_from_above = cos(angle_in_radians) < 0

      down_wall_hit = is_ball_in_contact_down_wall && is_ball_coming_from_below
      up_wall_hit = is_ball_in_contact_up_wall && is_ball_coming_from_above

      down_wall_hit or up_wall_hit
    end
  end

  def side_wall_brick_hit(brick)
    angle_in_radians = @angle/180 * PI
    is_ball_in_brick_vertical_range = down > brick.up && up < brick.down
    if is_ball_in_brick_vertical_range
      is_ball_in_contact_left_wall = right > brick.left && right <= brick.x + SizeValues::CONTACT_BUFFER
      is_ball_in_contact_right_wall =  left < brick.right && left >= brick.right - SizeValues::CONTACT_BUFFER
      is_ball_coming_from_left = sin(angle_in_radians) > 0
      is_ball_coming_from_right = sin(angle_in_radians) < 0

      left_wall_hit = is_ball_in_contact_left_wall && is_ball_coming_from_left
      right_wall_hit = is_ball_in_contact_right_wall && is_ball_coming_from_right

      left_wall_hit or right_wall_hit
    end
  end

  def contact_bricks(level)
    have_a_horizontal_hit = false
    have_a_vertical_hit = false
    level.bricks = level.bricks.reject do |brick|
      already_hit = brick_destroyed = false
      if !have_a_vertical_hit && vertical_wall_brick_hit(brick)
        @angle = (180 - @angle) % 360
        brick.get_hit(level)
        already_hit = true
        have_a_vertical_hit = true
      end
      if !have_a_horizontal_hit && !already_hit && side_wall_brick_hit(brick)
        @angle = (360 - @angle) % 360
        brick.get_hit(level)
        have_a_horizontal_hit = true
      end
      brick.hp.zero?
    end
  end
end