defmodule VinculiWeb.ConstellationChannel do
  use VinculiWeb, :channel

  alias VinculiGraph.Node
  alias VinculiGraph.Relationship

  def join("constellation:explore", %{"token" => token}, socket) do
    salt = VinculiWeb.Endpoint.config(:secret_key_base)
    case Phoenix.Token.verify(socket, salt, token, max_age: 2460) do
      {:ok, user_id} ->
        {:ok, assign(socket, :current_user, user_id)}
      {:error, reason} ->
        {:error, reason}
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

  @doc """
  Reply with the list of node labels used in database.
  """
  def handle_in("node:labels", _, socket) do
    data = Node.get_labels()
    {:reply, {:ok, %{data: data}}, socket}
  end

  @doc """
  Reply with the list of relationship typs used in database.
  """
  def handle_in("edge:types", _, socket) do
    data = Relationship.get_types()
    {:reply, {:ok, %{data: data}}, socket}
  end

  # Add authorization logic here as required.
  # defp authorized?(%{"token" => token} = payload, socket) do
  # end
end
