class StaticGameState < GameImage
  def initialize(image_x, image_y, image)
    super(image_x, image_y, image)
  end

  def start_game
    player = Player.new
    level = LevelOne.new
    InGameState.new(player, level)
  end

  def update
    if Gosu.button_down? Gosu::KB_SPACE
      start_game
    else
      self
    end
  end
end

class GameOver < StaticGameState
  def initialize
    loss_image_x = SizeValues::SCREEN_WIDTH/2 - SizeValues::LOSS_IMAGE_WIDTH/2
    loss_image_y = SizeValues::SCREEN_HEIGHT/2 - SizeValues::LOSS_IMAGE_HEIGHT/2
    game_over_img = Gosu::Image.new("media/GameOver.png")
    super(loss_image_x, loss_image_y, game_over_img)
  end
end

class Victory < StaticGameState
  def initialize
    victory_image_x = SizeValues::SCREEN_WIDTH/2 - SizeValues::VICTORY_IMAGE_WIDTH/2
    victory_image_y = SizeValues::SCREEN_HEIGHT/2 - SizeValues::VICTORY_IMAGE_HEIGHT/2
    victory_img = Gosu::Image.new("media/YouWon.png")
    super(victory_image_x, victory_image_y, victory_img)
  end
end

class InitMenu < StaticGameState
  def initialize
    init_img = Gosu::Image.new("media/Menu1.png")
    super(0, 0, init_img)
  end
end

class InGameState
  def initialize(player, level)
    @pause = true
    @player = player
    @level = level
  end

  def update
    state = self
    if @pause
      if Gosu.button_down? Gosu::KB_G
        @pause = false
      end
    else
      if Gosu.button_down? Gosu::KB_P
        @pause = true
      end
      if Gosu.button_down? Gosu::KB_LEFT
        @player.go_left
      end
      if Gosu.button_down? Gosu::KB_RIGHT
        @player.go_right
      end
      @level.update_bonuses
      @level.move_bonuses
      @level.update_balls(@player)
      @level.move_balls
      @player.contact_bonuses(@level)
      if(@level.over?)
        @pause = true
        @player.back_to_start
        case @level
        when LevelOne
          @level = LevelTwo.new
        when LevelTwo
          @level = LevelThree.new
        when LevelThree
          win = true
        end
      end
      if win
        state = Victory.new
      elsif @level.balls.empty?
        state = GameOver.new
      end
    end
    state
  end

  def draw
    @player.draw
    @level.draw
  end
end