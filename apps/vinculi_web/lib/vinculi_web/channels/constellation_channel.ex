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

  @doc """
  Reply with data for the requested node

  Requires a map formated as %{"uuid" => uuid, "labels" => labels}
  For example:
    %{"uuid" => "town-2, "labels" => ["Town"]}

  """
  def handle_in("node_local_graph", %{"uuid" => uuid, "labels" => labels}, socket) do
    data = Node.get_local_graph(List.first(labels), uuid, :cytoscape)
    {:reply, {:ok, %{data: data}}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
