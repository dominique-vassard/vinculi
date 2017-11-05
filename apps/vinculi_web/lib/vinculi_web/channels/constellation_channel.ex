defmodule VinculiWeb.ConstellationChannel do
  use VinculiWeb, :channel

  alias VinculiGraph.Node

  def join("constellation:explore", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (constellation:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # def handle_in("shout", payload, socket) do
  #   IO.puts inspect payload
  #   result = Map.put(payload, "sup", "non-visible")
  #   l = %{test: "value", other: "test2"}
  #   result = Map.put(result, "message", l)
  #   IO.puts ">>>>>>>>>>>>>> #{inspect result}"
  #   {:reply, {:ok, result}, socket}
  # end

  def handle_in("node_local_graph", %{"uuid" => uuid, "labels" => labels}, socket) do
    {:reply,
     {:ok, Node.get_local_graph(List.first(labels), uuid, :cytoscape)},
      socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
