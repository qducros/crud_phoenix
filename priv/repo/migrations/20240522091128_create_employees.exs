defmodule CrudPhoenix.Repo.Migrations.CreateEmployees do
  use Ecto.Migration

  def change do
    create table(:employees) do
      add :fullname, :string
      add :email, :string
      add :title, :string
      add :age, :integer

      timestamps(type: :utc_datetime)
    end

    create unique_index(:employees, [:email])
  end
end
