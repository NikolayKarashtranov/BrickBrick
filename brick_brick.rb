require 'gosu'
require 'fileutils'
require_relative 'src/values'
require_relative 'src/visual_game_object'
require_relative 'src/player'
require_relative 'src/ball'
require_relative 'src/brick'
require_relative 'src/level'
require_relative 'src/game_state'
require_relative 'src/bonus'

class BrickBrick < Gosu::Window
  def initialize
    FileUtils.mkdir_p 'save'
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
