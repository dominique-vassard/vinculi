defmodule VinculiApi.Router do
  use VinculiApi, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug VinculiApi.BasicAuthPlug
  end

  scope "/api", VinculiApi do
    pipe_through :api
    get "/test", TestController, :index
  end
end
