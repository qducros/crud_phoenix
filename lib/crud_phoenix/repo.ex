defmodule CrudPhoenix.Repo do
  use Ecto.Repo,
    otp_app: :crud_phoenix,
    adapter: Ecto.Adapters.Postgres
end
