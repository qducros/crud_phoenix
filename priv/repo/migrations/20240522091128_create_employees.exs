defmodule CrudPhoenix.Repo.Migrations.CreateEmployees do
  use Ecto.Migration

  def change do
    create table(:employees) do
      add :fullname, :string, null: false
      add :email, :string, null: false
      add :title, :string, null: false
      add :age, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:employees, [:email])
  end
end
