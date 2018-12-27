class GameOver
  include SizeValues
  def initialize
    @game_over = Gosu::Image.new("media/GameOver.png")
  end

  def draw
  	loss_image_x = screen_width/2 - loss_image_width/2
  	loss_image_y = screen_height/2 - loss_image_height/2
    @game_over.draw(loss_image_x, loss_image_y, 0)
  end
end