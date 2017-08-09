defmodule VinculiApiWeb.Router do
  use VinculiApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", VinculiApiWeb do
    pipe_through :api
    get "/test", TestController, :index
  end
end
