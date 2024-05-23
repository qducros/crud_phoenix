defmodule CrudPhoenix.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string, null: false
      add :logo, :string, null: false
      add :business, :string, null: false
      add :description, :text, null: false
      add :creation, :date, null: false
      add :headquarters, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:companies, [:name])
  end
end
