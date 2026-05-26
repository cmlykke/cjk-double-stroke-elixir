
defmodule CjkDoubleStroke do
  def add(a, b) when is_number(a) and is_number(b) do
    a + b
  end

  def add(_, _), do: {:error, :invalid_input}
end
