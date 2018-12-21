class VisualGameObject
	attr_accessor :x, :y, :width, :height, :image
	def initialize(x, y, width, height, image)
		@x = x
		@y = y
		@width = width
		@height = height
		@image = image
	end

	def draw
		@image.draw @x, @y, 0
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