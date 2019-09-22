defmodule Dl.Sched do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def init(state) do
    # Schedule work to be performed at some point
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    # Reschedule once more
    Dl.run()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    # In 30 minutes
    Process.send_after(self(), :work, 30 * 60 * 1000)
  end
end
