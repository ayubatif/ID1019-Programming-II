defmodule Chopstick do
	
	def start do 
		stick = spawn_link(fn -> init() end)
		{:stick, stick}
	end

	def init do 
		available()
	end

	def available() do
		receive do 
			{:request, from} -> send(from, :granted)
			gone()
			:quit -> :ok
		end
	end

	def gone() do
		receive do
			:return -> available()
			:quit -> :ok
		end
	end

	def quit({:stick, pid}) do
    	send(pid, :quit)
  	end

	def return({:stick, pid}) do
		send(pid, :return)
	end

	def terminate({:stick, pid}) do send(pid, :quit) end

	def request(stick = {:stick, pid}) do
		send(pid,{:request,self()})

		receive do
			:granted -> :ok
		end
	end


end