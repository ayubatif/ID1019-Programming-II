defmodule Sesame do

	def test() do
		test = start()
		send(test,'s')
		send(test,'e')
		send(test,'s')
		send(test,'a')
		send(test,'e')
		send(test,'m')
		send(test,'e')
		send(test,'e')
		send(test,'s')
		send(test,'e')
		send(test,'s')
		send(test,'a')
		send(test,'m')
		send(test,'e')
		send(test,'e')
		send(test,'e')
		send(test,'e')
		send(test,'')
	end

	def start() do
		spawn(fn() -> s() end)
	end

	def s() do
		receive do
			's' -> se()
			_ -> s()
		end
	end
	def se() do
		receive do
			's' -> se()
			'e' -> ses()
			_ -> s()
		end
	end
	def ses() do
		receive do
			's' -> sesa()
			_ -> s()
		end
	end
	def sesa() do
		receive do
			'a' -> sesam()
			'e' -> ses()
			's' -> se()
			_ -> s()
		end
	end
	def sesam() do
		receive do
			'm' -> sesame()
			's' -> se()
			_ -> s()
		end
	end
	def sesame() do
		receive do
			'e' -> open()
			's' -> se()
			_ -> s()
		end
	end
	def open() do
		#IO.puts("Sesame open")
		receive do
			_ -> IO.puts("Sesame open")
				open()
		end
	end
end