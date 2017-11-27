defmodule VinculiWeb.TokenTest do
    use VinculiWeb.ConnCase

    alias VinculiWeb.TokenPlug

    describe "Test call/2" do
        setup [:setup_login]

        @tag login: true
        test "add user_token to conn.assign", %{conn: conn} do
            n_conn =
                conn
                |> bypass_through(VinculiWeb.Router, [:protected])
                |> get("/")
                |> TokenPlug.call([])


            %{user_token: user_token} = n_conn.assigns
            assert user_token
        end
    end
end