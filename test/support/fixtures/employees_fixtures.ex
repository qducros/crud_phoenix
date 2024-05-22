defmodule CrudPhoenix.EmployeesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CrudPhoenix.Employees` context.
  """

  @doc """
  Generate a unique employee email.
  """
  def unique_employee_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a employee.
  """
  def employee_fixture(attrs \\ %{}) do
    {:ok, employee} =
      attrs
      |> Enum.into(%{
        age: 42,
        email: unique_employee_email(),
        fullname: "some fullname",
        title: "some title"
      })
      |> CrudPhoenix.Employees.create_employee()

    employee
  end
end
