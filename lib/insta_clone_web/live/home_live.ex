defmodule InstaCloneWeb.HomeLive do
  use InstaCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-2xl font-bold">Home</h1>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
