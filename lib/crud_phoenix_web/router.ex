defmodule CrudPhoenixWeb.Router do
  use CrudPhoenixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CrudPhoenixWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CrudPhoenixWeb do
    pipe_through :browser

    live "/companies", CompanyLive.Index, :index
    live "/companies/new", CompanyLive.Index, :new
    live "/companies/:id/edit", CompanyLive.Index, :edit
    live "/companies/:id/delete", CompanyLive.Index, :delete
    live "/companies/:id", CompanyLive.Show, :show
    live "/companies/:id/show/edit", CompanyLive.Show, :edit
    live "/companies/:id/show/delete", CompanyLive.Show, :delete

    live "/employees", EmployeeLive.Index, :index
    live "/employees/new", EmployeeLive.Index, :new
    live "/employees/:id/edit", EmployeeLive.Index, :edit
    live "/employees/:id/delete", EmployeeLive.Index, :delete
    live "/employees/:id", EmployeeLive.Show, :show
    live "/employees/:id/show/edit", EmployeeLive.Show, :edit
    live "/employees/:id/show/delete", EmployeeLive.Show, :delete

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", CrudPhoenixWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:crud_phoenix, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CrudPhoenixWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
