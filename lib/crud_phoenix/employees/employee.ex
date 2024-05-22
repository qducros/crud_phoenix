defmodule CrudPhoenix.Employees.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "employees" do
    field :title, :string
    field :fullname, :string
    field :email, :string
    field :age, :integer
    belongs_to :user, CrudPhoenix.Companies.Company

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:fullname, :email, :title, :age, :company_id])
    |> validate_required([:fullname, :email, :title, :age, :company_id])
    |> unique_constraint(:email)
  end
end
