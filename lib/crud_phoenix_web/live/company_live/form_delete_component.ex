defmodule CrudPhoenixWeb.CompanyLive.FormDeleteComponent do
  use CrudPhoenixWeb, :live_component

  alias CrudPhoenix.Companies

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Are you sure you want to delete the company <%= @company.name %>? This will also delete all related employees.</:subtitle>
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
    company = Companies.get_company!(id)

    case Companies.delete_company(company) do
      {:ok, _} ->
        delete_file!(company.logo)

        notify_parent({:deleted, company})
        socket = socket |> put_flash(:info, "Company deleted successfully")
        if socket.assigns.navigate do
          {:noreply, socket |> push_navigate(to: socket.assigns.navigate)}
        else
          {:noreply, socket |> push_patch(to: socket.assigns.patch)}
        end

      {:error, _changeset} ->
        {:noreply,
          socket
          |> put_flash(:error, "Error while deleting the company")
          |> push_patch(to: socket.assigns.patch)}
    end
  end

  defp delete_file!(company_logo) do
    if !is_nil(company_logo) do
      path = Path.join([:code.priv_dir(:crud_phoenix), "static", company_logo])
      File.rm!(path)
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
