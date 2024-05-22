defmodule CrudPhoenix.EmployeesTest do
  use CrudPhoenix.DataCase

  alias CrudPhoenix.Employees

  describe "employees" do
    alias CrudPhoenix.Employees.Employee

    import CrudPhoenix.EmployeesFixtures

    @invalid_attrs %{title: nil, fullname: nil, email: nil, age: nil}

    test "list_employees/0 returns all employees" do
      employee = employee_fixture()
      assert Employees.list_employees() == [employee]
    end

    test "get_employee!/1 returns the employee with given id" do
      employee = employee_fixture()
      assert Employees.get_employee!(employee.id) == employee
    end

    test "create_employee/1 with valid data creates a employee" do
      valid_attrs = %{title: "some title", fullname: "some fullname", email: "some email", age: 42}

      assert {:ok, %Employee{} = employee} = Employees.create_employee(valid_attrs)
      assert employee.title == "some title"
      assert employee.fullname == "some fullname"
      assert employee.email == "some email"
      assert employee.age == 42
    end

    test "create_employee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Employees.create_employee(@invalid_attrs)
    end

    test "update_employee/2 with valid data updates the employee" do
      employee = employee_fixture()
      update_attrs = %{title: "some updated title", fullname: "some updated fullname", email: "some updated email", age: 43}

      assert {:ok, %Employee{} = employee} = Employees.update_employee(employee, update_attrs)
      assert employee.title == "some updated title"
      assert employee.fullname == "some updated fullname"
      assert employee.email == "some updated email"
      assert employee.age == 43
    end

    test "update_employee/2 with invalid data returns error changeset" do
      employee = employee_fixture()
      assert {:error, %Ecto.Changeset{}} = Employees.update_employee(employee, @invalid_attrs)
      assert employee == Employees.get_employee!(employee.id)
    end

    test "delete_employee/1 deletes the employee" do
      employee = employee_fixture()
      assert {:ok, %Employee{}} = Employees.delete_employee(employee)
      assert_raise Ecto.NoResultsError, fn -> Employees.get_employee!(employee.id) end
    end

    test "change_employee/1 returns a employee changeset" do
      employee = employee_fixture()
      assert %Ecto.Changeset{} = Employees.change_employee(employee)
    end
  end
end
