defmodule VinculiWeb.ConstellationControllerTest do
  use VinculiWeb.ConnCase, async: true

  describe "Test search/2" do
    setup [:setup_login]

    @tag login: true
    test "valiod search results", %{conn: conn} do
      search_params = %{"search" =>
                        %{"label" => "Person",
                          "properties" => %{"aka" => "",
                                            "external_link" => "",
                                            "first_name" => "dav",
                                            "internal_link" => "",
                                            "last_name" => "hume"}
                         }
                        }
      conn = post conn, constellation_path(conn, :search, search_params)
      assert text_response(conn, 200)
    end
  end
end