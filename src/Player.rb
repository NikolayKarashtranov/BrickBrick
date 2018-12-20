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