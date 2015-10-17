defmodule CircuitBreaking.MusicSearcher do
  @fuse_name :itunes_music_search
  def search(query) do
    check_install_fuse

    case :fuse.ask(@fuse_name, :sync) do
      :ok ->
        CircuitBreaking.ItunesSearcher.search(query)
        |> parse_itunes_response(query)
      :blown ->
        CircuitBreaking.LocalSearcher.search(query)
    end
  end

  defp check_install_fuse do
    case :fuse.ask(@fuse_name, :sync) do
      {:error, :not_found} ->
        install_fuse
        _ -> :ok
    end
  end

  # installs fuse that will blow if there are 2 failures in 10 seconds
  # and reset after 60 more seconds
  defp install_fuse do
    :fuse.install(@fuse_name, {{:standard, 2, 10000}, {:reset, 60000}})
  end

  defp parse_itunes_response({:ok, %{"results" => results}}, _query) do
    Enum.map(results, fn(result) ->
      result["collectionName"]
    end)
  end

  defp parse_itunes_response({:error, _}, query) do
    :fuse.melt(@fuse_name)
    CircuitBreaking.LocalSearcher.search(query)
  end
end
