class GameImage
	attr_accessor :x, :y, :image
	def initialize(x, y, image)
		@x = x
		@y = y
		@image = image
	end

	def draw
		@image.draw @x, @y, 0
	end
end

class VisualGameObject < GameImage
	attr_accessor :width, :height
	def initialize(x, y, width, height, image)
		@width = width
		@height = height
		super(x, y, image)
	end

	def left
		@x
	end

	def up
		@y
	end

	def right
		@x + @width
	end

	def down
		@y + @height
	end
end