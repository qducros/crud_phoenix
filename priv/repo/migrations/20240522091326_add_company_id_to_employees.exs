defmodule CrudPhoenix.Repo.Migrations.AddCompanyIdToEmployees do
  use Ecto.Migration

  def change do
    alter table(:employees) do
      add :company_id, references(:companies, on_delete: :delete_all)
    end
  end
end
