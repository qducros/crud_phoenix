defmodule CrudPhoenixWeb.EmployeeLive.Index do
  use CrudPhoenixWeb, :live_view

  alias CrudPhoenix.Employees
  alias CrudPhoenix.Employees.Employee

  def filter_form(%{meta: meta} = assigns) do
    assigns = assign(assigns, form: Phoenix.Component.to_form(meta), meta: nil)

    ~H"""
    <.form
      for={@form}
      id={@id}
      class="flex my-4 gap-2"
      phx-change="update-filter"
      phx-submit="reset-filter"
    >
      <Flop.Phoenix.filter_fields
        :let={i}
        form={@form}
        fields={@fields}
        >
        <.input
          field={i.field}
          label={i.label}
          type={i.type}
          phx-debounce={120}
          {i.rest}
        />
      </Flop.Phoenix.filter_fields>

      <.button class="self-end pb-0" name="reset">Reset filters</.button>
    </.form>
    """
  end

  # @impl true
  # def mount(_params, _session, socket) do
  #   {:ok, stream(socket, :employees, Employees.list_employees())}
  # end

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

  defp apply_action(socket, :index, params) do
    case Employees.list_employees_with_params(params) do
      {employees, meta} ->
        socket
          |> assign(:page_title, "Listing Employees")
          |> assign(:meta, meta)
          |> stream(:employees, employees, reset: true)

      {_meta} ->
        socket
        |> assign(:page_title, "Listing Employees")
        |> push_navigate(to: ~p"/employees")
    end
  end

  @impl true
  def handle_info({CrudPhoenixWeb.EmployeeLive.FormComponent, {:saved, employee}}, socket) do
    {:noreply, stream_insert(socket, :employees, Employees.get_employee!(employee.id))}
  end

  @impl true
  def handle_info({CrudPhoenixWeb.EmployeeLive.FormDeleteComponent, {:deleted, employee}}, socket) do
    {:noreply, stream_delete(socket, :employees, employee)}
  end

  @impl true
  def handle_event("update-filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, push_patch(socket, to: ~p"/employees?#{params}")}
  end

  @impl true
  def handle_event("reset-filter", params, socket) do
    params = Map.delete(params, "filters")
    {:noreply, push_patch(socket, to: ~p"/employees?#{params}")}
  end
end
