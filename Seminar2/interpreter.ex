defmodule Env do

	def new() do 
		[]
	end

	def add(id, str, env) do
		[{id,str}|env]
	end

	def lookup(id,[]) do
		nil
	end
	def lookup(id,[{id,str}|tail]) do
		{id, str}
	end
	def lookup(id,[head|tail]) do
		lookup(id,tail)
	end

	def remove([id|[]],env)do
		remover(id,env)
	end
	def remove([head,tail],env) do
		remove(tail, remover(head,env))

	end
	def remover(id,env) do
		case lookup(id,env) do
			nil -> env
			{id, str} -> env -- [{id,str}]
		end

	end
end