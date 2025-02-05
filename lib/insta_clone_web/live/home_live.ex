defmodule InstaCloneWeb.HomeLive do
  use InstaCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-2xl font-bold">Home</h1>

    <.simple_form for{@form}>
    <.input field={@form[:caption]} type="textarea" label="Caption" required />
    </.simple_form>

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

    {:ok, socket}
  end
end
