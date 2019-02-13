defmodule Mandel do
	
	def mandelbrot(width, height,x,y,k,depth) do
		trans = fn(w,h) ->
			Cmplx.new(x+k * (w-1), y-k * (h-1)) end

		rows(width,height,trans,depth,[])
		end

	def rows(_, 0, _ ,_ ,rows) do rows end
	def rows(w, h, func, depth, rows) do
		row = row(w, h, func, depth, [])
		rows(w, h-1, func, depth, [row | rows])
	end

	def row(0, _, _, _, row) do row end
	def row(w, h, func, depth, row) do
		c = func.(w, h)
		res = Brot.mandelbrot(c, depth)
		color = Colors.convert(res, depth)
		row(w-1, h, func, depth, [color | row])
	end
end