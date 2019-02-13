defmodule Mandelbrot do
	def demo() do
		small(-1.31, 0, 0)
	end
	def small(x0, y0, xn) do
		width = 3840	
		height = 2260
		depth = 128
		k = (xn - x0) / width
		image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
		PPM.write("small.ppm", image)
	end
end

