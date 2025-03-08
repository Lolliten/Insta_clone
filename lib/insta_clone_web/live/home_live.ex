defmodule InstaCloneWeb.HomeLive do
  use InstaCloneWeb, :live_view
  import Phoenix.Component

  #alias InstaClone.Post
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
  #def render(%{loading: true} = assigns) do
    #~H"""
    #It's loading... ♥
    #"""
  #end


  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Posts Feed
        <:actions>
          <.link phx-click={show_modal("new-post-modal")}>
            <.button>Create Post</.button>
          </.link>
        </:actions>
      </.header>

      <.table
        id="posts"
        rows={@streams.posts}
      >
        <:col :let={{_id, post}} label="User"><%= post.user.email %></:col>
        <:col :let={{_id, post}} label="Image">
          <img src={post.image_path} class="w-32 h-32 object-cover" />
        </:col>
        <:col :let={{_id, post}} label="Caption"><%= post.caption %></:col>
        <:action :let={{_id, post}}>
          <div class="sr-only">
            <.link navigate={~p"/posts/#{post}"}>Show</.link>
          </div>
        </:action>
      </.table>

      <.modal
        id="new-post-modal"
        show={false}
      >
        <.live_component
          module={InstaCloneWeb.PostLive.FormComponent}
          id={:new}
          title="New Post"
          action={:new}
          uploads={@uploads}
          current_user={@current_user}
        />
      </.modal>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(InstaClone.Pubsub, "posts")
    end

    {:ok,
     socket
     |> assign(:page_title, "Posts Feed")
     |> allow_upload(:image, accept: ~w(.png .jpg), max_entries: 1)
     |> stream(:posts, Posts.list_posts())}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
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
      {:ok, post} ->
        socket =
          socket
          |> put_flash(:info, "Post created successfully")
          |> push_navigate(to: ~p"/home")

        Phoenix.PubSub.broadcast(InstaClone.PubSub, "posts", {:new, post})

        {:noreply, socket}
      {:error, _changeset} ->
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

  @impl true
  def handle_info({:new, post}, socket) do
    {:noreply, stream_insert(socket, :posts, post)}
  end
end
