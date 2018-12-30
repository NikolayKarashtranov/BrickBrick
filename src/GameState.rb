class StaticGameState < GameImage
  def initialize(image_x, image_y, image, window)
    super(image_x, image_y, image)
    @window = window
  end

  def start_game
    player = Player.new
    level = LevelOne.new
    InGameState.new(player, level, @window)
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
  def initialize(window)
    loss_image_x = SizeValues::SCREEN_WIDTH/2 - SizeValues::LOSS_IMAGE_WIDTH/2
    loss_image_y = SizeValues::SCREEN_HEIGHT/2 - SizeValues::LOSS_IMAGE_HEIGHT/2
    game_over_img = Gosu::Image.new("media/GameOver.png")
    super(loss_image_x, loss_image_y, game_over_img, window)
  end
end

class Victory < StaticGameState
  def initialize(window)
    victory_image_x = SizeValues::SCREEN_WIDTH/2 - SizeValues::VICTORY_IMAGE_WIDTH/2
    victory_image_y = SizeValues::SCREEN_HEIGHT/2 - SizeValues::VICTORY_IMAGE_HEIGHT/2
    victory_img = Gosu::Image.new("media/YouWon.png")
    super(victory_image_x, victory_image_y, victory_img, window)
  end
end

class InitMenu < StaticGameState
  def initialize(window)
    init_img = Gosu::Image.new("media/Menu1.png")
    super(0, 0, init_img, window)
  end

  def update
    if Gosu.button_down? Gosu::KB_SPACE
      start_game
    elsif Gosu.button_down? Gosu::KB_L
      LoadGameState.new(@window)
    else
      self
    end
  end
end

class InputTextState
    def initialize(window, title)
    @font = Gosu::Font.new(20, name: "Nimbus Mono L")
    window.text_input = Gosu::TextInput.new
    window.text_input.text = ""
    @window = window
    @title = title
  end

  def draw
    @font.draw_text(@title, SizeValues::SAVE_GAME_TEXT_X, SizeValues::SAVE_GAME_TEXT_Y, 0)
    @font.draw_text(@window.text_input.text, SizeValues::SAVE_GAME_INPUT_X, SizeValues::SAVE_GAME_INPUT_Y, 0)
  end
end

class LoadGameState < InputTextState
  def initialize(window)
    title = "Please enter a save game name and press Escape to load the game."
    super(window, title)
  end

  def positions_to_objs(info, angle = false)
    info.map do |el_info|
      el_class = el_info.shift
      if angle
        el = el_class.new(el_info[0], el_info[1], el_info[2])
      else
        el = el_class.new(el_info[0], el_info[1])
      end
    end
  end

  def load_game_state(info)
    level = info["level"].new
    level.bricks = positions_to_objs(info["bricks"])
    level.balls = positions_to_objs(info["balls"], true)
    level.bonuses = positions_to_objs(info["bonuses"])
    player = Player.new(info["player_pos"][0], info["player_pos"][1])
    InGameState.new(player, level, @window)
  end

  def load_game
    file_name = "save/" + @window.text_input.text + ".txt"
    begin
      loaded = Marshal.load(File.read(file_name))
      load_game_state(loaded)
    rescue => ex
      puts ex.message
      false
    end

  end

  def update
    if Gosu.button_down? Gosu::KB_ESCAPE
      loaded = load_game
      if loaded
        @window.text_input = nil
        loaded
      else
        self
      end
    else
      self
    end
  end
end

class SaveGameState < InputTextState
  def initialize(window, in_game)
    title = "Please enter save game name and press Escape to save the game."
    super(window, title)
    @in_game = in_game
  end

  def update
    if Gosu.button_down? Gosu::KB_ESCAPE
      save_game
      @window.text_input = nil
      @in_game
    else
      self
    end
  end

  def save_game
    file_name = "save/"+ @window.text_input.text + ".txt"
    File.open(file_name, "w") {|f| f.write(Marshal.dump(save_info))}
  end

  def objs_to_positions(arr, angle = false)
    arr.map do |el|
      el_info = Array.new
      el_info.push(el.class)
      el_info.push(el.x).push(el.y)
      el_info.push(el.angle) if angle
      el_info
    end
  end

  def save_info
    info = Hash.new
    player = @in_game.player
    player_pos = [player.x, player.y]
    level = @in_game.level
    info["level"] = level.class
    info["player_pos"] = player_pos
    info["balls"] = objs_to_positions(level.balls, true)
    info["bonuses"] = objs_to_positions(level.bonuses)
    info["bricks"] = objs_to_positions(level.bricks)
    info
  end
end

class InGameState
  attr_accessor :pause, :level, :player
  def initialize(player, level, window)
    @pause = true
    @player = player
    @level = level
    @window = window
  end

  def update
    state = self
    if Gosu.button_down? Gosu::KB_S
      @pause = true
      state = SaveGameState.new(@window, self)
    elsif @pause
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
      state = @level.update(@player, state)
    end
    state
   end

  def draw
    @player.draw
    @level.draw
  end
end