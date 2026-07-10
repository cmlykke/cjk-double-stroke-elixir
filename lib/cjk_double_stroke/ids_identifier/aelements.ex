defmodule CjkDoubleStroke.Idsidentifier.Aelements do
  @moduledoc """
  Loads A-elements data from file at runtime.
  Easier to debug and set breakpoints.
  """

  @external_resource "lib/staticfiles/customfiles/aelements.txt"

  # Public API
  def get_elements() do
    load_elements()
  end

  def get_letters() do
    load_letters()
  end

  defp load_letters() do
    path = "lib/staticfiles/customfiles/lettermapping.txt"

    case File.read(path) do
      {:ok, content} ->
        content
        |> String.split("\n", trim: true)
        |> Enum.reject(&String.starts_with?(&1, "#"))
        |> Enum.map(&parse_letters/1)
        |> Enum.reject(&is_nil/1)
        |> Map.new()                    # Convert list of tuples into a map

      {:error, reason} ->
        IO.warn("Failed to read lettermapping.txt: #{reason} (path: #{path})")
        %{}  # Return empty map on error instead of empty list
    end
  end

  defp parse_letters(line) do
    parts =
      line
      |> String.split(",", trim: true)
      |> Enum.map(&String.trim/1)

    case parts do
      [code, letter] ->
        {code, letter}          # This tuple format is perfect for Map.new()

      _ ->
        IO.warn("Invalid line format in lettermapping.txt: #{inspect(line)}")
        nil
    end
  end

  # Main loading function - easy to put breakpoints here
  defp load_elements() do
    path = "lib/staticfiles/customfiles/aelements.txt"

    case File.read(path) do
      {:ok, content} ->
        content
        |> String.split("\n", trim: true)
        |> Enum.reject(&String.starts_with?(&1, "#"))
        |> Enum.map(&parse_line/1)
        |> Enum.reject(&is_nil/1)          # Remove any bad lines

      {:error, reason} ->
        IO.warn("Failed to read a_elements.txt: #{reason} (path: #{path})")
        []
    end
  end

  # Separate parsing function - very easy to debug
  defp parse_line(line) do
    parts =
      line
      |> String.split(",", trim: true)
      |> Enum.map(&String.trim/1)

    case parts do
      [main, variant, codes_str] ->
        codes =
          codes_str
          |> String.split(",", trim: true)
          |> Enum.map(&String.trim/1)
          |> MapSet.new()

        {codes, variant, main}

      _ ->
        IO.warn("Invalid line format in a_elements.txt: #{inspect(line)}")
        nil
    end
  end
end

# ("customfiles/a_elements.txt")
