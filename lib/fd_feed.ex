defmodule FDFeed do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Phx.Repo

  @primary_key {:id, :id, autogenerate: true}

  schema "fd_feed" do
    field(:url, :string)

    many_to_many :tags, Phx.Tag,
      join_through: "fd_feed_tags",
      on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:url])
    |> validate_required([:url])
    |> put_assoc(:tags, parse_tags(attrs))
  end

  defp parse_tags(params)  do
    (params["tags"] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> insert_and_get_all()
  end

  defp insert_and_get_all([]) do
    []
  end

  defp insert_and_get_all(names) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    maps =
      Enum.map(names, &%{
        name: &1,
        inserted_at: timestamp,
        updated_at: timestamp
      })

    Repo.insert_all Phx.Tag, maps, on_conflict: :nothing
    Repo.all from t in Phx.Tag, where: t.name in ^names
  end

  def validate_url(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, url ->
      case url |> String.to_charlist() |> :http_uri.parse() do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || "invalid url: #{inspect(msg)}"}]
      end
    end)
  end
end
