class Player < VisualGameObject
  def initialize
    image = Gosu::Image.new("media/stick.png")
    super(SizeValues::PLAYER_STARTING_X, SizeValues::PLAYER_STARTING_Y, SizeValues::PLAYER_WIDTH, SizeValues::PLAYER_HEIGHT, image)
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
  end

  def contact_bonuses(level)
    level.bonuses = level.bonuses.reject do |bonus|
      if(bonus.down > up && bonus.down < down && bonus.right > left && bonus.left < right)
        bonus.activate(level)
        true
      else
        false
      end
    end
  end
end