defmodule Mix.Tasks.Fetch do
  use Mix.Task

  @shortdoc "Simply calls the Dl.run/0 function."
  def run(_) do
    Dl.run()
  end
end