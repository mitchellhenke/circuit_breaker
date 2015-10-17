defmodule CircuitBreaking.ItunesSearcher do
  def search(query) do
    default_params
    |> Map.put(:term, query)
    |> make_request
  end

  defp make_request(params) do
    url = "#{search_url()}?#{URI.encode_query(params)}"
    case HTTPoison.get(url, [], []) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode(body)
      error ->
        {:error, error}
    end
  end

  defp search_url do
    "https://itunes.apple.com/search"
  end

  defp default_params do
    %{
      limit: 3,
      country: "us",
      media: "music",
      entity: "album",
    }
  end
end
