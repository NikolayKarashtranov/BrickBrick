class Player < VisualGameObject
  attr_accessor :long
  def initialize(x_coord = SizeValues::PLAYER_STARTING_X, y_coord = SizeValues::PLAYER_STARTING_Y, long = false)
    if long
      image = Gosu::Image.new("media/stick_long.png")
      player_width = SizeValues::PLAYER_LONG_WIDTH
    else
      image = Gosu::Image.new("media/stick.png")
      player_width = SizeValues::PLAYER_WIDTH
    end
    @long = long
    super(x_coord, y_coord, player_width, SizeValues::PLAYER_HEIGHT, image)
  end

  def go_left
    if @x > SizeValues::PLAYER_STEP
      @x -= SizeValues::PLAYER_STEP
    else
      @x = 0
    end
  end

  def go_right
    if @x < SizeValues::SCREEN_WIDTH - @width - SizeValues::PLAYER_STEP
      @x += SizeValues::PLAYER_STEP
    else
      @x = SizeValues::SCREEN_WIDTH - @width
    end
  end

  def back_to_start
    @x = SizeValues::PLAYER_STARTING_X
    @y = SizeValues::PLAYER_STARTING_Y
    @x -= switch_length_offset if @long
  end

  def contact_bonuses(level)
    level.bonuses = level.bonuses.reject do |bonus|
      in_horizontal_range = bonus.right > left && bonus.left < right
      in_vertical_range = bonus.down > up && bonus.down < down
      if in_horizontal_range && in_vertical_range
        bonus.activate(level)
        true
      else
        false
      end
    end
  end

  def shorten
    @long = false
    @image = Gosu::Image.new('media/stick.png')
    @width = SizeValues::PLAYER_WIDTH
    @x += switch_length_offset
  end

  def fit_in_screen
    if @x < 0
      @x = 0
    elsif @x + @width > SizeValues::SCREEN_WIDTH
      @x = SizeValues::SCREEN_WIDTH - @width
    end
  end

  def lengthen
    @long = true
    @image = Gosu::Image.new('media/stick_long.png')
    @width = SizeValues::PLAYER_LONG_WIDTH
    @x -= switch_length_offset
    fit_in_screen
  end

  def switch_length_offset
    (SizeValues::PLAYER_LONG_WIDTH - SizeValues::PLAYER_WIDTH) / 2
  end

  def switch_length
    @long ? shorten : lengthen
  end
end
