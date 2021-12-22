defmodule MediaServerWeb.SeriesLive.Show do
  use MediaServerWeb, :live_view

  import Ecto.Query

  alias MediaServer.Media
  alias MediaServer.Providers.Sonarr
  alias MediaServer.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"serie" => serie}, _, socket) do

    show = Sonarr |> last(:inserted_at) |> Repo.one

    case HTTPoison.get("#{ show.url }/series/#{ serie }?apikey=#{ show.api_key }") do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        decoded = Jason.decode!(body)

        {:noreply, socket |> assign(:page_title, "#{ decoded["title"] } (#{ decoded["year"] })") |> assign(:decoded, decoded)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end
