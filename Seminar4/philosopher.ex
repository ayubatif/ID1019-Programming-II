defmodule Philosopher do
	def timestamp do
		{_megasec, sec, microsec} = :os.timestamp
		sec * 1000000 + microsec
	end

	@think 1000
	@eat 50
	@delay 200

	def start(hunger, right, left, name, ctrl) do 
		phil = spawn_link(fn -> init(hunger, right, left, name, ctrl) end)
	end

	def init(hunger, right, left, name, ctrl) do 
		thinking(hunger,right,left,name,ctrl)
	end

	def thinking(0, right, left, name, ctrl) do
		IO.puts("#{timestamp()}: #{name} is full!")
		send(ctrl, :done)
	end

	def thinking(1000, right, left, name, ctrl) do
		IO.puts("#{timestamp()}: #{name} starved to death!")
		send(ctrl, :done)
	end

	def thinking(hunger, right, left, name, ctrl) do
		IO.puts("#{timestamp()}: #{name} is thinking...")
		sleep(@think)
		waiting(hunger, right, left, name, ctrl)

	end

	def waiting(hunger, right, left, name, ctrl) do 
		IO.puts("#{timestamp()}: #{name} is waiting, hunger level: #{hunger}.")

		case Chopstick.request(left) do 
			:ok ->
				IO.puts("#{timestamp()}: #{name} received left chopstick!")
				sleep(@delay)

				case Chopstick.request(right) do
					:ok ->
						IO.puts("#{timestamp()}: #{name} received both chopsticks!")
						eating(hunger, right, left, name, ctrl)
					end
				end
		IO.puts("#{timestamp()}: #{name} +1")
		thinking(hunger+7, right, left, name, ctrl)
	end

	def eating(hunger, right, left, name, ctrl) do
		IO.puts("#{timestamp()}: #{name} is eating noodles!")

		sleep(@eat)
		Chopstick.return(left)
		Chopstick.return(right)

		thinking(hunger-1, right, left, name, ctrl)
	end

	def sleep(0) do :ok end 
	def sleep(t) do
		:timer.sleep(:rand.uniform(t))
	end
end