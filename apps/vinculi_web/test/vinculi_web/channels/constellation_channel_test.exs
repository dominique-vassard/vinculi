defmodule VinculiWeb.ConstellationChannelTest do
  use VinculiWeb.ChannelCase

  alias VinculiWeb.ConstellationChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(ConstellationChannel, "constellation:explore")

    {:ok, socket: socket}
  end

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
    data = [%{data: %{id: "country-1", labels: ["Country"], name: "Scotland"},
       group: "nodes"},
     %{data: %{id: "town-2", labels: ["Town"], name: "Kirkcaldy"}, group: "nodes"},
     %{data: %{id: "town-2+country-1", source: "town-2", target: "country-1", type: "IS_IN_COUNTRY"},
       group: "edges"}]

    assert_reply ref, :ok, %{data: ^data}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
