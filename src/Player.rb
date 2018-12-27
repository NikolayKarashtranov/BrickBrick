class Player < VisualGameObject
  include SizeValues

  def initialize
    image = Gosu::Image.new("media/stick.png")
    super(player_starting_x, player_starting_y, player_width, player_height, image)
  end

  def go_left
    if @x > player_step
      @x -= player_step
    else
      @x = 0
    end
  end

  def go_right
    if @x < screen_width - @width - player_step
      @x += player_step
    else
      @x = screen_width - @width
    end
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