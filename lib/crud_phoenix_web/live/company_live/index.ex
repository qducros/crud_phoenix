defmodule CrudPhoenixWeb.CompanyLive.Index do
  use CrudPhoenixWeb, :live_view

  alias CrudPhoenix.Companies
  alias CrudPhoenix.Companies.Company

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

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :delete, %{"id" => id}) do
    socket
    |> assign(:page_title, "Delete Company")
    |> assign(:company, Companies.get_company!(id))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Company")
    |> assign(:company, Companies.get_company!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Company")
    |> assign(:company, %Company{})
  end

  defp apply_action(socket, :index, params) do
    case Companies.list_companies_with_params(params) do
      {:ok, {companies, meta}} ->
        socket
          |> assign(:page_title, "Listing Companies")
          |> assign(:meta, meta)
          |> stream(:companies, companies, reset: true)

      {:error, _meta} ->
        socket
        |> assign(:page_title, "Listing Companies")
        |> push_navigate(to: ~p"/companies")
    end
  end

  @impl true
  def handle_info({CrudPhoenixWeb.CompanyLive.FormComponent, {:saved, company}}, socket) do
    {:noreply, stream_insert(socket, :companies, company)}
  end

  @impl true
  def handle_info({CrudPhoenixWeb.CompanyLive.FormDeleteComponent, {:deleted, company}}, socket) do
    {:noreply, stream_delete(socket, :companies, company)}
  end

  @impl true
  def handle_event("update-filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, push_patch(socket, to: ~p"/companies?#{params}")}
  end

  @impl true
  def handle_event("reset-filter", params, socket) do
    params = Map.delete(params, "filters")
    {:noreply, push_patch(socket, to: ~p"/companies?#{params}")}
  end
end
