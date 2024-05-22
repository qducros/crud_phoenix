defmodule CrudPhoenix.CompaniesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CrudPhoenix.Companies` context.
  """

  @doc """
  Generate a unique company name.
  """
  def unique_company_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        business: "some business",
        creation: ~D[2024-05-21],
        description: "some description",
        headquarters: "some headquarters",
        logo: "some logo",
        name: unique_company_name()
      })
      |> CrudPhoenix.Companies.create_company()

    company
  end
end
