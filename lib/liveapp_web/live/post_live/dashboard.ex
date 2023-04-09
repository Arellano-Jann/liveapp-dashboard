defmodule LiveappWeb.PostLive.Dashboard do
  use LiveappWeb, :live_view

  alias Liveapp.Timeline
  alias Liveapp.Timeline.Post

  @impl true
  def mount(_params, _session, socket) do
    # IO.inspect(socket, limit: :infinity, structs: false)
    IO.inspect(socket, pretty: true, label: "Socket in MOUNT")
    # {:ok, IO.inspect("stuff")}
    {:ok, stream(socket, :posts, Timeline.list_posts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    IO.inspect(params, pretty: true, label: "Params in handle params")
    {:noreply,
      socket
      |> assign(:posts, length(Timeline.list_posts()))}
    # {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  # def apply_action(socket, )

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New Post")
  #   |> assign(:post, %Post{})
  # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:page_title, "Listing Posts")
  #   |> assign(:post, nil)
  # end

  @impl true
  def handle_info({LiveappWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    {:noreply, stream_insert(socket, :posts, post)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Timeline.get_post!(id)
    {:ok, _} = Timeline.delete_post(post)

    {:noreply, stream_delete(socket, :posts, post)}
  end
end
