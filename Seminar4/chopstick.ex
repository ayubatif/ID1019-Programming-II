defmodule Chopstick do
	
	def start do 
		chopstick = spawn_link(fn -> available() end)
		{:chopstick, chopstick}
	end

	def available() do
		receive do 
			{:request, phil} -> send(phil, :granted)
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

	def request({:chopstick, pid}) do
		send(pid,{:request,self()})
		receive do
			:granted -> :ok
		end
	end

	def quit({:chopstick, pid}) do
    	send(pid, :quit)
  	end

	def return({:chopstick, pid}) do
		send(pid, :return)
	end

	def terminate({:chopstick, pid}) do send(pid, :quit) end

end