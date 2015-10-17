defmodule CircuitBreaking.LocalSearcher do
  @album_list ["Beauty Behind The Madness", "What A Time To Be Alive", "1989",
    "Kill The Lights", "x", "If You're Reading This It's Too Late", "Blurryface",
    "In The Lonely Hour", "Hozier", "Graduation", "Late Registration",
    "Liquid Swords", "1999"]

  def search(query) do
    query = String.downcase(query)

    Enum.filter(@album_list, fn(title) ->
      String.downcase(title)
      |> String.contains?(query)
    end)
    |> Enum.take(3)
  end
end

