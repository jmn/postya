defmodule PhxWeb.FDFeedView do
  use PhxWeb, :view

  def format_tags(tags) do
    tags
    |> Enum.map(fn tag -> tag.name end)
    |> Enum.intersperse(", ")
  end
end
