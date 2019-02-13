defmodule Philosopher do
	@dream 1000
	@eat 50
	@delay 200


	def start(hunger, right, left, name, ctrl) do 
		philo = spawn_link(fn -> init(hunger, right, left, name, ctrl) end)
		{:philo, philo}
	end

	def init(hunger, right, left, name, ctrl) do 
		dreaming(hunger,right,left,name,ctrl)
	end

	def dreaming(0, right, left, name, ctrl) do
		IO.puts("#{name} is full")
		send(ctrl, :done)
	end

	def dreaming(1000, right, left, name, ctrl) do
		IO.puts("#{name} starved to death")
		send(ctrl, :done)
	end

	def dreaming(hunger, right, left, name, ctrl) do
		IO.puts("#{name} is dreaming...")
		sleep(@dream)
		waiting(hunger, right, left, name, ctrl)

	end

	def waiting(hunger, right, left, name, ctrl) do 
		IO.puts("#{name} is waiting, #{hunger}")

		case Chopstick.request(left) do 
			:ok ->
				sleep(@delay)

				case Chopstick.request(right) do
					:ok ->
						IO.puts("#{name} got sticks!")
						eating(hunger, right, left, name, ctrl)
					end
				end
		IO.puts("#{name} +1")
		dreaming(hunger+7, right, left, name, ctrl)
	end

	def eating(hunger, right, left, name, ctrl) do
		IO.puts("#{name} is eating")

		sleep(@eat)
		Chopstick.return(left)
		Chopstick.return(right)

		dreaming(hunger-1, right, left, name, ctrl)
	end

	def sleep(0) do :ok end 
	def sleep(t) do
		:timer.sleep(:rand.uniform(t))
	end
end