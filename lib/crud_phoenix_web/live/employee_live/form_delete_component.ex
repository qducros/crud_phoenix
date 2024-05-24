defmodule CrudPhoenixWeb.EmployeeLive.FormDeleteComponent do
  use CrudPhoenixWeb, :live_component

  alias CrudPhoenix.Employees

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Are you sure you want to delete the employee <%= @employee.fullname %>?</:subtitle>
      </.header>
      <br>
      <.button
        phx-disable-with="Deleting..."
        phx-target={@myself}
        phx-value-id={@id}
        phx-click="delete"
        >Delete</.button>
    </div>
    """
  end

  @impl true
  def handle_event("delete", %{"id"  => id}, socket) do
    employee = Employees.get_employee!(id)

    case Employees.delete_employee(employee) do
      {:ok, _} ->
        notify_parent({:deleted, employee})
        socket = socket |> put_flash(:info, "Employee deleted successfully")
        if Map.has_key?(socket.assigns, :navigate) do
          {:noreply, socket |> push_navigate(to: socket.assigns.navigate)}
        else
          {:noreply, socket |> push_patch(to: socket.assigns.patch)}
        end

      {:error, _changeset} ->
        {:noreply,
          socket
          |> put_flash(:error, "Error while deleting the employee")
          |> push_patch(to: socket.assigns.patch)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
