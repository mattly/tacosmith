defmodule TacoSmith.YAML do

  def process_frontmatter(record = %TacoSmith.Content{}) do
    body = Enum.join(record.body)
    {front_matter, body} = extract_frontmatter(body)
    if front_matter do
      yaml = :yamerl_constr.string(front_matter) |> hd |> yamerl_to_dict
      %TacoSmith.Content{ record | body: [body], info: Dict.merge(record.info, yaml) }
    else
      record
    end
  end

  defp extract_frontmatter(body) do
    case String.split(body, "\n", parts: 2) do
      ["---" | body] ->
        [yaml_text | body] = String.split(hd(body), "\n---\n", parts: 2)
        {yaml_text, body}
      _ -> {nil, body}
    end
  end

  def yamerl_to_dict(dict) do
    yamerl_to_dict(%{}, dict)
  end

  defp yamerl_to_dict(dict=%{}, []), do: dict
  defp yamerl_to_dict(dict=%{}, [head | tail]) do
    key = head |> elem(0) |> to_string |> String.to_atom
    value = head |> elem(1)
    if is_list(value), do: value = to_string(value)
    yamerl_to_dict(Dict.put(dict, key, value), tail)
  end

end
