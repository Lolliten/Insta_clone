defmodule InstaClone.Posts do
  import Ecto.Query, warn: false

  alias InstaClone.Repo
  alias InstaClone.Posts.Post

  def list_posts do
    query =
      from p in Post,
      select: p,
      order_by: [desc: inserted_at],
      preload: [:user]

    Repo.all(query)
  end

  # First we call Post.changeset to create a changeset
  # Then we call Repo.insert to insert the post into the database
  def save(post_params) do
    %Post{}
    |> Post.changeset(post_params)
    |> Repo.insert()
  end
end
