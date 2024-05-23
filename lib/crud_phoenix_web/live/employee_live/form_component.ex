defmodule CrudPhoenixWeb.EmployeeLive.FormComponent do
  use CrudPhoenixWeb, :live_component

  alias CrudPhoenix.Employees

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage employee records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="employee-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:fullname]} type="text" label="Full Name" />
        <.input field={@form[:email]} type="text" label="Email" />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:age]} type="number" label="Age" />
        <.input field={@form[:company_id]} type="select" label="Company" options={@options} prompt="Select the company" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Employee</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{employee: employee} = assigns, socket) do
    changeset = Employees.change_employee(employee)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"employee" => employee_params}, socket) do
    changeset =
      socket.assigns.employee
      |> Employees.change_employee(employee_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"employee" => employee_params}, socket) do
    save_employee(socket, socket.assigns.action, employee_params)
  end

  defp save_employee(socket, :edit, employee_params) do
    case Employees.update_employee(socket.assigns.employee, employee_params) do
      {:ok, employee} ->
        notify_parent({:saved, employee})

        {:noreply,
         socket
         |> put_flash(:info, "Employee updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_employee(socket, :new, employee_params) do
    case Employees.create_employee(employee_params) do
      {:ok, employee} ->
        notify_parent({:saved, employee})

        {:noreply,
         socket
         |> put_flash(:info, "Employee created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    options = CrudPhoenix.Companies.list_company_names_ids()
    socket
      |> assign(:form, to_form(changeset))
      |> assign(:options, options)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
