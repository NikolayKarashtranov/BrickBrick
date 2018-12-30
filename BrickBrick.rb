require 'gosu'
include Math
require_relative 'src/Values'
require_relative 'src/VisualGameObject'
require_relative 'src/Player'
require_relative 'src/Ball'
require_relative 'src/Brick'
require_relative 'src/Level'
require_relative 'src/GameState'
require_relative 'src/Bonus'

class BrickBrick < Gosu::Window
  def initialize
    super SizeValues::SCREEN_WIDTH, SizeValues::SCREEN_HEIGHT
    self.caption = self.class.to_s
    @state = InitMenu.new(self)
  end

  def update
    @state = @state.update
  end

  def draw
    @state.draw
  end
end

BrickBrick.new.show