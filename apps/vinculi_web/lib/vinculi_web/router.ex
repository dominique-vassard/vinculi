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
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true  # Add this
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
    # Add public routes below
  end

  scope "/", VinculiWeb do
    pipe_through :protected
    # Add protected routes below
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", VinculiWeb do
  #   pipe_through :api
  # end
end
