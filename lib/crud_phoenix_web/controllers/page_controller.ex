defmodule CrudPhoenixWeb.PageController do
  use CrudPhoenixWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # render(conn, :home, layout: false)
    redirect(conn, to: "/companies")
  end
end
