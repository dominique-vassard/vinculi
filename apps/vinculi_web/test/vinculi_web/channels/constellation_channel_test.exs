defmodule VinculiWeb.ConstellationChannelTest do
  use VinculiWeb.ChannelCase

  alias VinculiWeb.ConstellationChannel

  setup do
    user = insert_user(%{})
    salt = VinculiWeb.Endpoint.config(:secret_key_base)
    token = Phoenix.Token.sign(VinculiWeb.Endpoint, salt, user.id)

    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(ConstellationChannel, "constellation:explore", %{"token" => token})

    {:ok, socket: socket}
  end

  # setup do
  #   user = insert_user(%{})
  #   salt = VinculiWeb.Endpoint.config(:secret_key_base)
  #   token = Phoenix.Token.sign(VinculiWeb.Endpoint, salt, user.id)
  #   # {:ok, socket} = connect(VinculiWeb.UserSocket, %{"token" => token})

  #   socket("", %{})
  #     |> subscribe_and_join(ConstellationChannel, "constellation:explore", %{token: token})
  # end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to constellation:explore", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "node_local_graph reply to constellation:explore", %{socket: socket} do
    ref = push socket, "node_local_graph", %{"uuid" => "town-2", "labels" => ["Town"]}
    data = [
      %{data: %{id: "country-1", labels: ["Country"], lat: 56.4907,
      long: -4.2026, name: "Scotland"}, group: "nodes"},
      %{data: %{id: "town-2", labels: ["Town"], name: "Kirkcaldy"},
      group: "nodes"},
      %{data: %{id: "town-2+country-1", source: "town-2", target:
      "country-1", type: "IS_IN_COUNTRY"}, group: "edges"}]

    assert_reply ref, :ok, %{data: ^data}
  end

  test "node:labels reply with node labels list", %{socket: socket} do
    ref = push socket, "node:labels"
    data = [
      "Town", "Country", "Continent", "Language", "Degree", "Year",
      "Institution", "Profession", "Domain", "School", "Person", "Publication",
      "Translation"]
    assert_reply ref, :ok, %{data: ^data}
  end

  test "edge:types reply with relationship types list", %{socket: socket} do
    ref = push socket, "edge:types"

    data = [
      "IS_IN_COUNTRY", "IS_IN_CONTINENT", "WHERE_BORN", "WHEN_BORN",
      "WHERE_DIED", "WHEN_DIED", "WROTE", "WHEN_WRITTEN", "IS_OF_DOMAIN",
      "IS_OF_SCHOOL", "HAS_ORIGINAL_LANGUAGE", "HAS_DEGREE", "DEGREE_FROM",
      "HAS_PROFESSION", "EMPLOYED_BY", "EMPLOYED_FROM", "EMPLOYED_TO",
      "TRANSLATED", "TRANSLATED_IN_LANGUAGE", "WHEN_TRANSLATED", "CO_WROTE",
      "INFLUENCED"]

    assert_reply ref, :ok, %{data: ^data}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
