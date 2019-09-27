defmodule Phx.Blog.Post.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
end

defmodule Phx.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Phx.Blog.Post
  alias Phx.Blog.Post.TitleSlug

  schema "posts" do
    field :content, :string
    field :title, :string
    field :slug, TitleSlug.Type

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
    |> unique_constraint(:title)
    |> TitleSlug.maybe_generate_slug
    |> TitleSlug.unique_constraint
  end

  defimpl Phoenix.Param, for: Phx.Blog.Post do
    def to_param(%{slug: slug}) do
      "#{slug}"
    end
  end
end
