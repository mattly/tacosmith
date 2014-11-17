defmodule TacoSmith.YAML do

  @yaml_file_re ~r/\.(yaml|yml)$/

  alias TacoSmith.Site
  alias TacoSmith.Content

  def frontmatter(site = %Site{}) do
    filter = ~r/\.(md|markdown)$/
    TacoSmith.process(site, filter, &process_frontmatter/1)
  end

  def process_frontmatter(record = %Content{}) do
    body = Enum.join(record.body)
    {front_matter, body} = extract_frontmatter(body)
    if front_matter do
      yaml = yaml_to_dict(front_matter)
      %Content{ record | body: [body], info: Dict.merge(record.info, yaml) }
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

  def sidecar(site = %Site{}) do
    yaml_files = site.files
              |> Enum.filter(&(String.match?(&1.info.path, @yaml_file_re)))
              |> Enum.map(&(String.replace(&1.info.path, @yaml_file_re, "")))
    {target_files, rest} = Enum.partition(site.files, &(Enum.member?(yaml_files, &1.info.path)))
    target_and_yaml_files = Enum.map(target_files, fn(record) ->
      yaml_file = Enum.find(rest, &(String.match?(&1.info.path, ~r/^#{record.info.path}\.(yaml|yml)$/)))
      yaml = yaml_file.body |> Enum.join |> yaml_to_dict
      {%Content{ record | info: Dict.merge(record.info, yaml) }, yaml_file}
    end)
    target_files = Enum.map(target_and_yaml_files, &(elem(&1, 0)))
    %Site{ site | files: Enum.concat(target_files, rest) }
  end

  defp yaml_to_dict(string) do
    dict = :yamerl_constr.string(string) |> hd |> yamerl_to_dict
    if Dict.has_key?(dict, :date) do
      dict = Dict.put(dict, :date, TacoSmith.Utils.date(dict.date))
    end
    dict
  end

  defp yamerl_to_dict(yamerl), do: yamerl_to_dict(%{}, yamerl)

  defp yamerl_to_dict(dict=%{}, []), do: dict
  defp yamerl_to_dict(dict=%{}, [head | tail]) do
    key = head |> elem(0) |> to_string |> String.to_atom
    value = head |> elem(1)
    if is_list(value), do: value = to_string(value)
    yamerl_to_dict(Dict.put(dict, key, value), tail)
  end

end
