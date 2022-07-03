defmodule TomatoWeb.Router do
  use TomatoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TomatoWeb do
    pipe_through :api

    get "/facebook_webhook", FacebookController, :verify_webhook_token
    post "/facebook_webhook", FacebookController, :handle_event
  end
end
