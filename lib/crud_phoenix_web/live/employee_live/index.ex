defmodule CrudPhoenixWeb.EmployeeLive.Index do
  use CrudPhoenixWeb, :live_view

  alias CrudPhoenix.Employees
  alias CrudPhoenix.Employees.Employee

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :employees, Employees.list_employees())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :delete, %{"id" => id}) do
    socket
    |> assign(:page_title, "Delete Employee")
    |> assign(:employee, Employees.get_employee!(id))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Employee")
    |> assign(:employee, Employees.get_employee!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Employee")
    |> assign(:employee, %Employee{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Employees")
    |> assign(:employee, nil)
  end

  @impl true
  def handle_info({CrudPhoenixWeb.EmployeeLive.FormComponent, {:saved, employee}}, socket) do
    {:noreply, stream_insert(socket, :employees, Employees.get_employee!(employee.id))}
  end

  @impl true
  def handle_info({CrudPhoenixWeb.EmployeeLive.FormDeleteComponent, {:deleted, employee}}, socket) do
    {:noreply, stream_delete(socket, :employees, employee)}
  end
end
