defmodule CrudPhoenixWeb.CompanyLive.Show do
  use CrudPhoenixWeb, :live_view

  alias CrudPhoenix.Companies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {company, employee_count, last_five_employees} = Companies.get_company_with_employees!(id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:company, company)
     |> assign(:employee_count, employee_count)
     |> assign(:last_five_employees, last_five_employees)}
  end

  defp page_title(:show), do: "Show Company"
  defp page_title(:edit), do: "Edit Company"
  defp page_title(:delete), do: "Delete Company"
end
