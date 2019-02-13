defmodule Huffman do

	def sample do
		'the quick brown fox jumps over the lazy dog
  this is a sample text that we will use when we build
  up a table we will handle lower case letters and no punctuation
  symbols the frequency will of course not represent
  english but it is probably not that far off'
	end

	def text, do: 'this is something that we should encode'
	
	def test do
		sample = sample()
		tree = tree(sample)
		encode = encode_table(tree)
		#text = text()
		seq = encode(sample, encode)
		decode(seq, encode)
	end
	def tree(sample) do
		freq = freq(sample)
		huffman(freq)
	end
	def huffman(freq) do 
		freq = List.keysort(freq,1)
		construct(freq)
	end
	
	def construct([head|[]])do
		head
	end
	def construct(freq)do
		construct(build(freq))
	end

	def build([])do
		[]
	end
	def build([head|[]])do
		[head]
	end
	def build([{c1,f1}|[{c2,f2} | tail]]) do 
		[{{c1,c2},f1+f2}|build(tail)]
	end



	def encode_table({tree,freq}) do
		encode_recursive(tree,[])
	end

	def encode_recursive({a,b},list)do
		first = encode_recursive(a,[0|list])
		second = encode_recursive(b,[1|list])

		first ++ second
	end
	def encode_recursive(single,list)do
		[{single,Enum.reverse(list)}]
	end


	def decode_table(tree) do
		# To implement...
	end
	def encode([char|[]],table)do
		find(char, table)
	end
	def encode([char|tail], table) do
		find(char,table) ++ encode(tail,table)
	end
	def find(char, [{char,path}|tail])do
		path
	end
	def find(char, [{random,_}|tail])do
		find(char,tail)
	end


	def decode([], _) do
		[]
	end
	
	def decode(seq, table) do
		{char,rest} = decode_char(seq,1,table)
		[char | decode(rest, table)]
	end
	
	def decode_char(seq,n, table)do
		{code, rest} = Enum.split(seq,n)

		case List.keyfind(table,code, 1) do
			{char,path} ->
				{char,rest}
			nil ->
				decode_char(seq, n+1, table)
			end
	end

	#Freqqqqqqqq
	def freq(sample) do
		freq(sample,[])
	end
	def freq([], freq) do
		freq
	end
	def freq([char | rest], freq) do
		freq(rest, update(char,freq))
	end

	def update(char, []) do
		[{char,1}]
	end
	def update(char,[{char,count} | tail]) do
		[{char,count + 1} | tail]
	end
	def update(char, [head | tail]) do 
		[head | update(char, tail)]
	end
	

end