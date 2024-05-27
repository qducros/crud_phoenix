defmodule CrudPhoenixWeb.CompanyLive.FormComponent do
  use CrudPhoenixWeb, :live_component

  alias CrudPhoenix.Companies

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage company records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="company-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:business]} type="text" label="Business" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:creation]} type="date" label="Creation" />
        <.input field={@form[:headquarters]} type="text" label="Headquarters" />

        <.live_file_input upload={@uploads.logo} />
        <%= for entry <- @uploads.logo.entries do %>
          <figure>
            <.live_img_preview entry={entry} />
            <figcaption><%= entry.client_name %></figcaption>
          </figure>
          <progress value={entry.progress} max="100"><%= entry.progress %>%</progress>
          <%= for err <- upload_errors(@uploads.logo, entry) do %>
            <p role="alert" class="mt-3 flex gap-3 text-sm leading-6 text-rose-600 phx-no-feedback:hidden"><%= error_to_string(err) %></p>
          <% end %>
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving...">Save Company</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{company: company} = assigns, socket) do
    changeset = Companies.change_company(company)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> assign(:uploaded_files, [])
     |> allow_upload(:logo, accept: ~w(.jpg .png .jpeg), max_entries: 1)}
  end

  @impl true
  def handle_event("validate", %{"company" => company_params}, socket) do
    changeset =
      socket.assigns.company
      |> Companies.change_company(company_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"company" => company_params}, socket) do
    save_company(socket, socket.assigns.action, company_params)
  end

  defp save_company(socket, :edit, company_params) do
    {:ok, company_params} = save_file(socket, company_params)
    case Companies.update_company(socket.assigns.company, company_params) do
      {:ok, company} ->
        notify_parent({:saved, company})

        {:noreply,
         socket
         |> put_flash(:info, "Company updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_company(socket, :new, company_params) do
    {:ok, company_params} = save_file(socket, company_params)
    case Companies.create_company(company_params) do
      {:ok, company} ->
        notify_parent({:saved, company})

        {:noreply,
         socket
         |> put_flash(:info, "Company created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_file(socket, company_params) do
    image_files =
      consume_uploaded_entries(socket, :logo, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:crud_phoenix), "static", "uploads", Path.basename(path)])

        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

      company_params = if length(image_files) > 0 do
      [file | _] = image_files
      Map.put(company_params, "logo", file)
    else
      Map.put(company_params, "logo", nil)
    end

    {:ok, company_params}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
