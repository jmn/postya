defmodule PhxWeb.LayoutView do
  use PhxWeb, :view
  import Ecto.Query

  def get_tags() do
    Phx.Repo.all(
      from t in FDTag,
        left_join: up in assoc(t, :fd_feed),
        preload: :fd_feed,
        distinct: true,
        select: t,
        where: fragment("? IN (SELECT fd_tag_id FROM fd_feed_tags)", t.id)
    )
    |> Enum.map(& &1.name)
  end
end
