defmodule InstaClone.Posts do
  # First we call Post.changeset to create a changeset
  # Then we call Repo.insert to insert the post into the database
  def save(post_params) do
    %Post{}
    |> Post.changeset(post_params)
    |> Repo.insert()
  end
end
