defmodule ParamountLandscapingWeb.JobLive.Index do
  use ParamountLandscapingWeb, :live_view

  alias ParamountLandscaping.Jobs
  alias ParamountLandscaping.Jobs.Job

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :jobs, Jobs.list_jobs(preload: [:line_items, :labors]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Job")
    |> assign(:job, Jobs.get_job!(id, preload: [:line_items, :labors]))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Job")
    |> assign(:job, %Job{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Jobs")
    |> assign(:job, nil)
  end

  @impl true
  def handle_info({ParamountLandscapingWeb.JobLive.FormComponent, {:saved, job}}, socket) do
    job = Jobs.get_job!(job.id, preload: [:line_items, :labors])
    {:noreply, stream_insert(socket, :jobs, job)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    job = Jobs.get_job!(id, preload: [:line_items, :labors])
    {:ok, _} = Jobs.delete_job(job)

    {:noreply, stream_delete(socket, :jobs, job)}
  end
end
