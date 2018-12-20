require 'gosu'
include Math
require_relative 'src/Player'
require_relative 'src/Ball'
require_relative 'src/Brick'
require_relative 'src/Level'
require_relative 'src/Victory'
require_relative 'src/GameOver'
require_relative 'src/Bonus'

class BrickBrick < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "BrickBrick"    
    @player = Player.new
    GameOver.initialize
    Victory.initialize
    @level = LevelOne.new
    
    @game_over = @win = false
  end

  def update
    if Gosu.button_down? Gosu::KB_LEFT
      @player.go_left
    end

    if Gosu.button_down? Gosu::KB_RIGHT
      @player.go_right
    end

    if @game_over || @win
      if Gosu.button_down? Gosu::KB_SPACE
        initialize
      end
    end

    @level.update_bonuses()
    @level.move_bonuses()
    @level.update_balls()
    @level.balls.each do |ball|
      ball.contact_player(@player)
      ball.contact_walls
      ball.contact_bricks(@level)
    end
    @player.contact_bonuses(@level)
    if(@level.over?)
      case @level.next
      when 2
        @level = LevelTwo.new
      when 3
        @level = LevelThree.new
      when 4
        @win = true
      end
    end
    @game_over = @level.balls.empty?
  end

  def draw
    if !@game_over && !@win
      @player.draw
      @level.draw  
    elsif @win
      Victory.draw
    else
      GameOver.draw
    end
  end
end

BrickBrick.new.show