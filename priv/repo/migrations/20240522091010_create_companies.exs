defmodule CrudPhoenix.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :logo, :string
      add :business, :string
      add :description, :text
      add :creation, :date
      add :headquarters, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:companies, [:name])
  end
end
