defmodule InstaCloneWeb.HomeLive do
  use InstaCloneWeb, :live_view

  alias InstaClone.Post

  @doc """
  Renders the home page.
  The modal hides the form, to create a new post the user most click the button.
  Post param calls the post.ex post schema.
  Post params is a map that contains the post data.
  Since the route is behind authentication, the post data will contain the user_id.
  Read in officials: https://hexdocs.pm/phoenix_live_view/uploads.html
  """

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-2xl font-bold">Home</h1>

    <button type="button" phx-click={show_modal("new-post-modal")}>Create Post</button>
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
    form =
      %Post{}
      |> Post.changeset(%{})
      |> to_form(as: "post")

    socket =
      socket
      |> assign(form: form)
      |> allow_upload(:image, accept: ~w(.png .jpg), max_entries: 1)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save post", %{"post" => post_params}, socket) do
    %{current_user: user_id} = socket.assigns

    post_params
      |> Map.put("user_id", user_id)

    {:noreply, socket}
  end

  defp uploaded_files(socket) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
      dest = Path.join([:code.priv_dir(:insta_clone), "static", "uploads", Path.basename(path)])

      File.cp!(path, dest)
      {:ok, ~p"/uploads/#{Path.basename(dest)}"}
    end)
  end
end
