defmodule QueueApplication.Queue do
  use GenServer

  # Client.
  def start_link(initial_queue \\ []), do: GenServer.start_link(__MODULE__, initial_queue)

  def enqueue(pid, element), do: GenServer.cast(pid, {:enqueue, element})

  def dequeue(pid), do: GenServer.call(pid, :dequeue)

  # Server callbacks.
  @impl true
  def init(initial_queue) when is_list(initial_queue), do: {:ok, initial_queue}

  @impl true
  def handle_cast({:enqueue, element}, queue), do: {:noreply, queue ++ [element]}

  @impl true
  def handle_call(:dequeue, _from, []), do: {:reply, nil, []}
  @impl true
  def handle_call(:dequeue, _from, [head | tail]), do: {:reply, head, tail}
end
