defmodule Pingpong do

	import :timer
	@timer 500
	def start() do
		ping = spawn_link(fn -> ping() end)
		pong = spawn_link(fn -> pong() end)
		#IO.puts(ping)
		send(ping, {pong,'pong'})
	end
	def ping() do
		receive do
			{pid,'pong'} -> IO.puts("Ping")
							send(pid,{self(),'ping'})
							sleep @timer
							ping()
		end
	end

	def pong() do
		receive do
			{pid,'ping'} -> IO.puts("Pong")
							send(pid,{self(),'pong'})
							sleep @timer
							pong()
		end
	end

end