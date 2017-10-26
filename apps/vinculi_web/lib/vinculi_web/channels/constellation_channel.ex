defmodule VinculiWeb.ConstellationChannel do
  use VinculiWeb, :channel

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

  def handle_in("node_local_graph", payload, socket) do
    node = %{group: "nodes", labels: ["Domain"], name: "Anthropology", uuid: "domain-2"}

    result = %{edges: [%{end: "publication-22", group: "edges", start: "person-9",
           type: "WROTE"},
         %{end: "year-29", group: "edges", start: "publication-22",
           type: "WHEN_WRITTEN"},
         %{end: "language-3", group: "edges", start: "publication-22",
           type: "HAS_ORIGINAL_LANGUAGE"},
         %{end: "domain-2", group: "edges", start: "publication-22",
           type: "IS_OF_DOMAIN"}],
        nodes: [%{firstName: "Marcel", group: "nodes", labels: ["Person"],
           lastName: "MAUSS", name: "Marcel MAUSS", uuid: "person-9"},
         %{group: "nodes", labels: ["Publication"], name: "",
           title: "Esquisse d'une théorie générale de la magie",
           uuid: "publication-22"},
         %{group: "nodes", labels: ["Year"], name: "1902", uuid: "year-29",
           value: 1902},
         %{group: "nodes", labels: ["Language"], name: "French", uuid: "language-3"},
         %{group: "nodes", labels: ["Domain"], name: "Anthropology",
           uuid: "domain-2"}]}

    return = %{data: node}
    IO.puts inspect return
    {:reply, {:ok, node}, socket}
    # broadcast socket, "request for: #{payload}", payload

  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
