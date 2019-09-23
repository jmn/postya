defmodule FDFeed do
  use Ecto.Schema
  import Ecto.Changeset
  
  @primary_key {:id, :id, autogenerate: true}

  schema "fd_feed" do
    field(:url, :string)
  end

  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end

def validate_url(changeset, field, options \\ []) do
  validate_change changeset, field, fn _, url ->
    case url |> String.to_char_list |> :http_uri.parse do
      {:ok, _} -> []
      {:error, msg} -> [{field, options[:message] || "invalid url: #{inspect msg}"}]
    end
  end
end

end
