class VisualGameObject
	attr_accessor :x, :y, :width, :height
	def initialize(x, y, width, height)
		@x = x
		@y = y
		@width = width
		@height = height
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