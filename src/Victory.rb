class Victory
  include SizeValues
  def initialize
    @victory = Gosu::Image.new("media/YouWon.png")
  end

  def draw
  	victory_image_x = screen_width/2 - victory_image_width/2
  	victory_image_y = screen_height/2 - victory_image_height/2
    @victory.draw(victory_image_x, victory_image_y, 0)
  end
end