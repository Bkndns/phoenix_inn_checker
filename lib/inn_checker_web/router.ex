defmodule InnCheckerWeb.Router do
  use InnCheckerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :with_session do
    plug Guardian.Plug.Pipeline, module: InnChecker.Guardian, error_handler: InnChecker.Auth.GuardianErrorHandler #InnCheckerWeb.SessionController
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug InnCheckerWeb.CurrentUser
  end

  pipeline :login_required do
    plug Guardian.Plug.EnsureAuthenticated, handler: InnChecker.Auth.GuardianErrorHandler
  end

  pipeline :admin_required do
    plug InnCheckerWeb.CheckAdmin
  end

  scope "/", InnCheckerWeb do
    pipe_through [:browser, :with_session]

    resources "/", HistoryController, only: [:index, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]



    scope "/admin", Admin, as: :admin do
      pipe_through [:login_required, :admin_required]

      resources "/history", HistoryController, only: [:index, :show, :delete]
      resources "/users", UserController, only: [:index, :show]
      resources "/block", BlockController, only: [:index, :delete, :create]
    end


  end

  # Other scopes may use custom stacks.
  # scope "/api", InnCheckerWeb do
  #   pipe_through :api
  # end
end
