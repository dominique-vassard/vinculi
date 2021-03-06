defmodule VinculiWeb.Router do
  use VinculiWeb, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
    plug VinculiWeb.LocalePlug
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
    plug VinculiWeb.TokenPlug
    plug VinculiWeb.LocalePlug
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug VinculiWeb.BasicAuthPlug
  end

  # Add this block
  scope "/", VinculiWeb do
    pipe_through :browser
    coherence_routes()
  end

  # Add this block
  scope "/", VinculiWeb do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", VinculiWeb do
    pipe_through :browser
    get "/constellation/index", ConstellationController, :index
    # Add public routes below
  end

  scope "/", VinculiWeb do
    pipe_through :protected
    # Add protected routes below
    get "/", PageController, :index
    get "/constellation/explore/:labels/:node_uuid", ConstellationController, :explore

    # post "/constellation/search", ConstellationController, :search

    # Test pages
    get "/restrict1", PageController, :restrict_one
    get "/restrict2", PageController, :restrict_two
    get "/restrict3", PageController, :restrict_three
  end

  scope "/api", VinculiApi do
    pipe_through :api
    get "/test", TestController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", VinculiWeb do
  #   pipe_through :api
  # end
end
