defmodule InstaCloneWeb.PostLive.FormComponent do
  use InstaCloneWeb, :live_component

  alias InstaClone.Posts
  alias InstaClone.Post

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h2><%= @title %></h2>
      <.simple_form
        for={@form}
        id="post-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.live_file_input upload={@uploads.image} required />
        <.input field={@form[:caption]} type="textarea" label="Caption" required />
        <:actions>
          <.button phx-disable-with="Saving...">Save Post</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{action: :new} = assigns, socket) do
    changeset = Posts.change_post(%Post{})  # Ensure you have a function to create a changeset

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      %Post{}
      |> Posts.change_post(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"post" => post_params}, socket) do
    post_params =
      post_params
      |> Map.put("user_id", socket.assigns.current_user.id)
      |> Map.put("image_path", List.first(consume_files(socket)))

    case Posts.create_post(post_params) do
      {:ok, post} ->
        Phoenix.PubSub.broadcast(InstaClone.PubSub, "posts", {:new, post})
        {:noreply, socket |> put_flash(:info, "Post created successfully") |> push_navigate(to: ~p"/home")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
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
