
defmodule CjkDoubleStroke.Utils do




  def is_shape_char?(char) when is_binary(char) do
    case String.next_codepoint(char) do
      {<<cp::utf8>>, ""} ->
        cp in 0x2FF0..0x2FFF
      _ ->
        false
    end
  end

  def remove_shape_chars(string) when is_binary(string) do
    string
    |> String.graphemes()
    |> Enum.reject(&is_shape_char?/1)
    |> Enum.join("")
  end


  def is_chinese?(char) when is_binary(char) do
    if String.length(char) == 1 do
      case String.next_codepoint(char) do
        {<<cp::utf8>>, ""} ->
          cp in 0x2E80..0x2EFF or    # CJK Radicals Supplement
          cp in 0x2F00..0x2FDF or    # Kangxi Radicals
          cp in 0x31C0..0x31EF or    # CJK Strokes
          cp in 0x3400..0x4DBF or    # CJK Unified Ideographs Extension A

          cp in 0x4E00..0x9FFF or    # CJK Unified Ideographs
          cp in 0xF900..0xFAFF or    # CJK Compatibility Ideographs
          cp in 0xFE30..0xFE4F or    # CJK Compatibility Forms
          cp in 0x20000..0x2A6DF or  # CJK Unified Ideographs Extension B

          cp in 0x2A700..0x2B73F or  # Extension C
          cp in 0x2B740..0x2B81F or  # Extension D
          cp in 0x2B820..0x2CEAF or  # Extension E
          cp in 0x2CEB0..0x2EBEF or  # Extension F
          cp in 0x2EBF0..0x2EE5F or  # Extension I
          cp in 0x2F800..0x2FA1F or         # CJK Compatibility Ideographs Supplement
          cp in 0x30000..0x3134F or         # Extension G
          cp in 0x31350..0x323AF or         # Extension H
          cp in 0x323B0..0x3347F            # Extension J
      _ -> false
    end

    else
      false
    end
  end




end
