module GameOver
  def self.initialize
    @@game_over = Gosu::Image.new("media/GameOver.png")
  end

  def self.draw
    @@game_over.draw 158, 188, 0
  end
end