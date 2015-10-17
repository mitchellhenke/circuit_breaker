defmodule CircuitBreaking.ItunesSearcher do
  use HTTPoison.Base
  def search_music(query) do
    default_params
    |> Map.put(:term, query)
    |> make_request
  end

  defp make_request(params) do
    url = "#{search_url()}?#{URI.encode_query(params)}"
    case get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode(body)
      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        {:error, {code, body}}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp search_url do
    "https://itunes.apple.com/search"
  end

  defp default_params do
    %{
      limit: 10,
      country: "us",
      media: "music",
      entity: "song,album",
    }
  end
end
