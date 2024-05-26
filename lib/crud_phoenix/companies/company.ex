defmodule CrudPhoenix.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:name, :business, :headquarters],
    sortable: [:name, :creation],
    max_limit: 100,
    default_limit: 10,
    default_order: %{
      order_by: [:name],
      order_directions: [:asc]
    }
  }

  schema "companies" do
    field :creation, :date
    field :name, :string
    field :description, :string
    field :logo, :string
    field :business, :string
    field :headquarters, :string
    has_many(:employees, CrudPhoenix.Employees.Employee)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :logo, :business, :description, :creation, :headquarters])
    |> validate_required([:name, :logo, :business, :description, :creation, :headquarters])
    |> unique_constraint(:name)
  end
end
