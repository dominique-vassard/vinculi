defmodule VinculiWeb.TokenPlug do
    import Plug.Conn

    def init(opts) do
        opts
    end

    def call(conn, _) do
        user = Coherence.current_user(conn)
        if user do
            salt = VinculiWeb.Endpoint.config(:secret_key_base)
            token = Phoenix.Token.sign(conn, salt, user.id)
            assign(conn, :user_token, token)
        else
            conn
        end
    end
end