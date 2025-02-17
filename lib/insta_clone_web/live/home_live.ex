defmodule InstaCloneWeb.HomeLive do
  use InstaCloneWeb, :live_view

  alias InstaClone.Post
  alias InstaClone.Posts

  @doc """
  Renders the home page.
  The modal hides the form, to create a new post the user most click the button.
  Post param calls the post.ex post schema.
  Post params is a map that contains the post data.
  Since the route is behind authentication, the post data will contain the user_id.
  Read in officials: https://hexdocs.pm/phoenix_live_view/uploads.html
  """

  @impl true
  def render(%{loading: true} = assigns) do
    ~H"""
    It's loading... ♥
    """
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-2xl font-bold">Home</h1>

    <button type="button" phx-click={show_modal("new-post-modal")}>Create Post</button>

    <div id="feed" phx-update="stream" class="flex flex-col gap-2">
      <%= for {dom_id, post} <- @stream.posts do %>
        <div id={dom_id} class="w-1/2 mx-auto flex-col gap-2 border-rounded">
          <img src={post.image_path} />
          <p><%= post.user.email %></p>
          <p><%= post.caption %></p>
        </div>
      <% end %>
    </div>

    <.modal id="new-post-modal">
      <.simple_form for={@form} phx-change="validate" phx-submit="save_post">
        <.live_file_input upload={@uploads.image} required />
        <.input field={@form[:caption]} type="textarea" label="Caption" required />
        <.button type="submit" phx-disable-with="Saving...">Create Post</.button>
      </.simple_form>
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true ->
        form =
          %Post{}
          |> Post.changeset(%{})
          |> to_form(as: "post")

        posts = Posts.list_posts()

        socket =
          socket
          |> assign(form: form, loading: false)
          |> allow_upload(:image, accept: ~w(.png .jpg), max_entries: 1)
          |> stream(:posts, posts)

        {:ok, assign(socket, loading: true)}

      false ->
        {:ok, socket}
    end
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save post", %{"post" => post_params}, socket) do
    %{current_user: user_id} = socket.assigns

    # First we call user_id
    # Then we call image_path
    # Post.save is defined in post.ex
    # Use push_navigate instead of push_path to close the post modal, (avoids javascript)
    post_params
    |> Map.put("user_id", user_id)
    |> Map.put("image_path", List.first(consume_files(socket)))
    |> Posts.save()
    |> case do
      {:ok, _post} ->
          socket =
            socket
            |> put_flash(:info, "Post created successfully")
            |> push_navigate(to: ~p"/home")
        {:error, changeset} ->
          {:noreply, socket}
    end
  end

  defp consume_files(socket) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
      dest = Path.join([:code.priv_dir(:insta_clone), "static", "uploads", Path.basename(path)])

      File.cp!(path, dest)
      {:ok, ~p"/uploads/#{Path.basename(dest)}"}
    end)
  end
end
