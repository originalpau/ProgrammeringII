defmodule Philosopher do
  @dream 1
  @eat 1
  @delay 0
  @timeout :infinity

  def sleep(0) do :ok end
  def sleep(t) do :timer.sleep(:rand.uniform(t)) end

  def start(hunger, right, left, name, ctrl, waiter) do
    spawn_link(fn() -> dreaming(hunger, right, left, name, ctrl, waiter) end)
  end

  def dreaming(0, _, _, name, ctrl, _) do
    IO.puts("#{name} is done eating")
    send(ctrl, :done)
  end

  def dreaming(hunger, right, left, name, ctrl, waiter) do
    IO.puts("#{name} is dreaming...")
    sleep(@dream)
    IO.puts("#{name} wakes up!")
    #waiting(hunger, right, left, name, ctrl, waiter)
    sit(hunger, right, left, name, ctrl, waiter)
  end

  # defp waiting(hunger, right, left, name, ctrl, waiter) do
  #   IO.puts("#{name} is waiting for chopsticks, #{hunger} left")
  #   case Chopstick.request(left) do
  #     {:ok, :granted} ->
  #       IO.puts("#{name} received a chopstick!")
  #       sleep(@delay)
  #       case Chopstick.request(right) do
  #         {:ok, :granted} ->
  #           IO.puts("#{name} received both chopstick!")
  #           eat(hunger, right, left, name, ctrl, waiter)
  #       end
  #   end
  # end

  # Break the deadlock with request and timeout
  # Does not break, only waiting for a dead process
  # defp waiting(hunger, right, left, name, ctrl, waiter) do
  #   IO.puts("#{name} is waiting for chopsticks, #{hunger} left")
  #   case Chopstick.request(left, @timeout) do
  #     :no ->
  #       IO.puts("#{name} did not get a chopstick.")
  #       #waiting(hunger, right, left, name, ctrl)

  #       {:ok, :granted} ->
  #       IO.puts("#{name} received a chopstick!")
  #       case Chopstick.request(right, @timeout) do
  #         :no ->
  #           IO.puts("#{name} did not receive both chopstick.")
  #           #Chopstick.return(left)
  #           #waiting(hunger, right, left, name, ctrl)

  #         {:ok, :granted} ->
  #           IO.puts("#{name} received both chopstick!")
  #           eat(hunger, right, left, name, ctrl, waiter)
  #       end
  #   end
  # end

  # Asynchronous function
  # När det både är asynkront och med timeout, så blir cykeln av hämtning
  # mycket kortare för varje filosof, därför är det mindre sannolikt att
  # två filosofer håller på samma chopstick samtidigt.
  defp waiting(hunger, right, left, name, ctrl, waiter) do
    IO.puts("#{name} is waiting for chopsticks, #{hunger} left")
    left_ref = Chopstick.request(left)
    right_ref = Chopstick.request(right)

    case Chopstick.granted(left_ref) do
      :no ->
        IO.puts("#{name} did not get a chopstick.")
        #waiting(hunger, right, left, name, ctrl)

      {:ok, ^left_ref} ->
        IO.puts("#{name} received left chopstick!")
        case Chopstick.granted(right_ref) do
          :no -> IO.puts("#{name} did not get the right chopstick.")
          {:ok, ^right_ref} ->
            IO.puts("#{name} received right chopstick!")
            eat(hunger, right, left, name, ctrl, waiter)
        end

    end
  end

  # Introduce a waiter
  defp sit(hunger, right, left, name, ctrl, waiter) do
    IO.puts("#{name} asking waiter to be seated...")
    send(waiter, {:sit, name, self()})
    receive do
      :serve -> waiting(hunger, right, left, name, ctrl, waiter)
    end
  end

  def eat(hunger, right, left, name, ctrl, waiter) do
    IO.puts("#{name} is eating, #{hunger} left")
    sleep(@eat)
    Chopstick.return(left)
    Chopstick.return(right)
    dreaming(hunger-1, right, left, name, ctrl, waiter)
    #leave(hunger, right, left, name, ctrl, waiter)
  end

   # Introduce a waiter
  defp leave(hunger, right, left, name, ctrl, waiter) do
    IO.puts("#{name} asking waiter to leave...")
    send(waiter, {:leave, name, self()})
    receive do
      :left -> dreaming(hunger-1, right, left, name, ctrl, waiter)
    end
  end

end

# left = Chopstick.start
# right = Chopstick.start
# name = "Rudolf"
# pid = spawn(fn() -> Philosopher.start(5, left, right, name, self()) end)

# 4.Experiments: When @dream 1, they only get one chopstick. No one gets to eat.
# :rand.uniform(n) ger ett random integer 1 =< x =< n
# @dream 1 innebär att alla filosofer alltid drömmer 1 ms och vaknar samtidigt.
# @delay innan request av nästa chopstick gör att filosoferna väntar in dem andra. Men ingen har lämnat tillbaka sin nuvarande
# i handen, vilket gör att de 5 chopstick är :gone. Ingen är available så den når aldrig dit och meddelandet väntar i brevlådan.
# Request väntar på svar som aldrig kommer -> deadlock och crash -> tar ner sin parent processor i Dinner.

# 5. Break the deadlock: request med timeout + return gör att vi kan
# fortsätta trots @dream 1
# Request med timeout, @dream 1, utan return gör dock att alla filosofer fortfarande inte kan fortsätta då inga
# chopsticks blir tillgängliga.

# :rand.seed(:exsss, {1234, 1234, 1234})
# Process.get(:rand_seed)
# Ej nödvändigt längre att sätta ett seed då default algoritmen gör detta per automatik när
# uniform/1 kallas. Uppgiftsbeskrivningen är gammal.
