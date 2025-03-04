defmodule CrudPhoenix.Companies do
  @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false
  alias CrudPhoenix.Repo

  alias CrudPhoenix.Companies.Company
  alias CrudPhoenix.Employees.Employee

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies()
      [%Company{}, ...]

  """
  def list_companies do
    Repo.all(Company)
  end

  def list_companies_with_params(params) do
    query = from c in Company,
        left_join: e in Employee, on: c.id == e.company_id,
        group_by: c.id,
        select: %{c | employee_count: count(e.id) |> selected_as(:employee_count)}

    Flop.validate_and_run(query, params, for: Company)
  end

  def list_company_names_ids do
    Company
    |> Repo.all()
    |> Enum.map(&{&1.name, &1.id})
  end

  def list_company_ids do
    Company
    |> Repo.all()
    |> Enum.map(& &1.id)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id)

  def get_company_with_employees!(id) do
    company = Company
    |> Repo.get!(id)
    |> Repo.preload(:employees)

    employee_count = company
    |> Map.get(:employees)
    |> Enum.count()

    last_five_employees = from(e in Employee,
      where: e.company_id == ^company.id,
      order_by: [desc: e.inserted_at],
      limit: 5
    )
    |> Repo.all()

    {company, employee_count, last_five_employees}
  end

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Company{} = company, attrs \\ %{}) do
    Company.changeset(company, attrs)
  end
end
