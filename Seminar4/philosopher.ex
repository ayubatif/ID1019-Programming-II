defmodule Philosopher do
	def timestamp do
		{_megasec, sec, microsec} = :os.timestamp
		sec * 1000000 + microsec
	end

	@think 10
	@eat 500
	@delay 500
	@timeout 2000

	def start(hunger, left, right, name, ctrl) do 
		phil = spawn_link(fn -> thinking(hunger, left, right, name, ctrl) end)
	end

	def thinking(0, left, right, name, ctrl) do
		IO.puts("#{timestamp()}: #{name} is full! hunger level: 0")
		send(ctrl, :done)
	end

	def thinking(10, left, right, name, ctrl) do
		IO.puts("#{timestamp()}: #{name} starved to death! hunger level: 10")
		send(ctrl, :done)
	end

	def thinking(hunger, left, right, name, ctrl) do
		IO.puts("#{timestamp()}: #{name} is pretending to be a philosopher... hunger level: #{hunger}")
		sleep(@think*hunger)
		waitingAsync(hunger, left, right, name, ctrl)

	end

	def waitingAsync(hunger, left, right, name, ctrl) do 
		IO.puts("#{timestamp()}: #{name} is waiting for chopsticks... hunger level: #{hunger}")
		request_left_chopstick = Chopstick.request(left, 2000)
		request_right_chopstick = Chopstick.request(right, 2000)
		
		cond do
			request_left_chopstick==:ok && request_right_chopstick==:ok ->
				IO.puts("#{timestamp()}: #{name} received both chopsticks! hunger level: #{hunger}")
				eating(hunger, left, right, name, ctrl)
			request_left_chopstick==:ok ->
				IO.puts("#{timestamp()}: #{name} can't get right chopstick... hunger level: #{hunger}")
				Chopstick.return(left)
			request_right_chopstick==:ok ->
				Chopstick.return(right)
				IO.puts("#{timestamp()}: #{name} can't get left chopstick... hunger level: #{hunger}")
			true ->
				IO.puts("#{timestamp()}: #{name} can't get chopsticks... hunger level: #{hunger}")
				thinking(hunger+1, left, right, name, ctrl)
		end
	end

	# def waitingSync(hunger, left, right, name, ctrl) do 
	# 	IO.puts("#{timestamp()}: #{name} is waiting for left chopstick. hunger level: #{hunger}")

	# 	case Chopstick.request(left, 2000) do 
	# 		:ok ->
	# 			IO.puts("#{timestamp()}: #{name} received left chopstick! hunger level: #{hunger}")
	# 			sleep(@delay)
	# 			case Chopstick.request(right, 2000) do
	# 				:ok ->
	# 					IO.puts("#{timestamp()}: #{name} received both chopsticks! hunger level: #{hunger}")
	# 					eating(hunger, left, right, name, ctrl)
	# 				:no ->
	# 					IO.puts("#{timestamp()}: #{name} was denied right chopstick! He returns left chopstick... hunger level: #{hunger+1}")
	# 					Chopstick.return(left)
	# 					thinking(hunger+1, left, right, name, ctrl)
	# 			end
	# 		:no ->
	# 			IO.puts("#{timestamp()}: #{name} was denied left chopstick! hunger level: #{hunger+1}")
	# 			thinking(hunger+1, left, right, name, ctrl)
	# 	end
	# end

	def eating(hunger, left, right, name, ctrl) do
		IO.puts("#{timestamp()}: #{name} is eating some good ICA noodles! hunger level: #{hunger-1}")
		sleep(@eat)
		Chopstick.return(left)
		Chopstick.return(right)
		IO.puts("#{timestamp()}: #{name} has returned their chopsticks. hunger level: #{hunger-1}")
		thinking(hunger-1, left, right, name, ctrl)
	end

	def sleep(0) do :ok end 
	def sleep(t) do
		:timer.sleep(:rand.uniform(t))
	end
end