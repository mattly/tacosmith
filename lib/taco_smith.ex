defmodule TacoSmith do
  defp pmap(coll, fun) do
    Enum.map(coll, fn(item) -> Task.async(fn -> fun.(item) end) end)
    |> Enum.map(&Task.await/1)
  end

  def list(source) do
    Path.wildcard("./#{source}/**")
    |> Enum.filter(&File.regular?/1)
    |> Enum.map(&(String.replace(&1, "./#{source}/", "")))
    |> Enum.map(&(TacoSmith.Content.create("./#{source}", &1)))
  end

  def process(collection, filter=%Regex{}, fun)
  when is_list(collection)
  and is_function(fun) do
    process(collection, &(Regex.match?(filter, &1.info.path)), fun)
  end

  def process(collection, filter_fun, process_fun)
  when is_list(collection)
  and is_function(filter_fun)
  and is_function(process_fun) do
    {matches, rest} = Enum.partition(collection, filter_fun)
    pmap(matches, process_fun)
    |> Enum.filter(&(&1))
    |> Enum.concat(rest)
  end

  def process(collection, fun)
  when is_list(collection)
  and is_function(fun), do: process(collection, fn(_) -> true end, fun)

  def clean(dest) do
    File.rm_rf "./#{dest}"
    File.mkdir "./#{dest}"
  end

  def write_all(list, config = %{}) when is_list(list) do
    clean(config.dest)
    list
    |> Enum.each fn(record) ->
      filepath = Path.join(config.dest, record.info.path)
      dir = Path.dirname(filepath)
      if dir != '.' && ! File.exists?(dir), do: File.mkdir_p!(dir)
      File.write!(filepath, Enum.join(record.body))
    end
    :ok
  end

end
