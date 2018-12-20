module Victory
  def self.initialize
    @@victory = Gosu::Image.new("media/YouWon.png")
  end

  def self.draw
    @@victory.draw 155, 188, 0
  end
end