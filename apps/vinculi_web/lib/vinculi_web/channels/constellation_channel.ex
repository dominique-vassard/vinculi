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
    node = %{data: %{labels: ["Domain"], name: "Anthropology", uuid: "domain-2"}}

    result = %{edges: [%{data: %{source: "person-9", target: "publication-22",
       type: "WROTE"}},
   %{data: %{source: "publication-22", target: "language-3",
       type: "HAS_ORIGINAL_LANGUAGE"}},
   %{data: %{source: "publication-22", target: "year-29",
       type: "WHEN_WRITTEN"}},
   %{data: %{source: "publication-22", target: "domain-2",
       type: "IS_OF_DOMAIN"}}],
  nodes: [%{data: %{firstName: "Marcel", id: "person-9", labels: ["Person"],
       lastName: "MAUSS", name: "Marcel MAUSS"}},
   %{data: %{id: "publication-22", labels: ["Publication"], name: "",
       title: "Esquisse d'une théorie générale de la magie"}},
   %{data: %{id: "language-3", labels: ["Language"], name: "French"}},
   %{data: %{id: "year-29", labels: ["Year"], name: "1902", value: 1902}},
   %{data: %{id: "domain-2", labels: ["Domain"], name: "Anthropology"}}]}

    return = %{data: node}
    IO.puts inspect return
    {:reply, {:ok, result}, socket}
    # broadcast socket, "request for: #{payload}", payload

  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
