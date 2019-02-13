defmodule Mergesort do
	
	def sort([]) do
		[]
	end
	def sort([e]) do
		[e]
	end
	def sort(list) do
		{left,right} = split(list)
		merge(sort(left),sort(right))
	end
	


	def merge(list, []) do
		list
	end
	def merge([], list) do
		list
	end
	def merge(l1 = [h1|t1], l2 = [h2|t2]) do
		if(h1 < h2) do
			[h1|merge(t1,l2)]
		else
			[h2|merge(t2,l1)]
		end
	end



	def split([head|tail]) do
		split(tail,[head],[])
	end
	def split([head|tail],left,[]) do
		split(tail,[head],left)
	end
	def split([head|tail], left, right) do
		split(tail, [head|right], left)
	end
	def split([], left, right) do 
		{left,right}
	end
end
