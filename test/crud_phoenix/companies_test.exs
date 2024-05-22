defmodule CrudPhoenix.CompaniesTest do
  use CrudPhoenix.DataCase

  alias CrudPhoenix.Companies

  describe "companies" do
    alias CrudPhoenix.Companies.Company

    import CrudPhoenix.CompaniesFixtures

    @invalid_attrs %{creation: nil, name: nil, description: nil, logo: nil, business: nil, headquarters: nil}

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Companies.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{creation: ~D[2024-05-21], name: "some name", description: "some description", logo: "some logo", business: "some business", headquarters: "some headquarters"}

      assert {:ok, %Company{} = company} = Companies.create_company(valid_attrs)
      assert company.creation == ~D[2024-05-21]
      assert company.name == "some name"
      assert company.description == "some description"
      assert company.logo == "some logo"
      assert company.business == "some business"
      assert company.headquarters == "some headquarters"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      update_attrs = %{creation: ~D[2024-05-22], name: "some updated name", description: "some updated description", logo: "some updated logo", business: "some updated business", headquarters: "some updated headquarters"}

      assert {:ok, %Company{} = company} = Companies.update_company(company, update_attrs)
      assert company.creation == ~D[2024-05-22]
      assert company.name == "some updated name"
      assert company.description == "some updated description"
      assert company.logo == "some updated logo"
      assert company.business == "some updated business"
      assert company.headquarters == "some updated headquarters"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end
end
