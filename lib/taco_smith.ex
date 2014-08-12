defmodule TacoSmith do

  def list(source) do
    Path.wildcard("./#{source}/**")
    |> Enum.filter(&File.regular?/1)
    |> Enum.map(&(String.replace(&1, "./#{source}/", "")))
    |> Enum.map(&(TacoSmith.Content.create("./#{source}", &1)))
  end

  def process(collection, filter=%Regex{}, fun)
  when is_list(collection) and is_function(fun) do
    {matches, rest} = Enum.partition(collection, &(String.match?(&1.info.path, filter)))
    fun.(matches)
    |> Enum.concat(rest)
  end

  def process_each(collection, filter=%Regex{}, fun)
  when is_list(collection) and is_function(fun) do
    process(collection, filter, fn(coll) -> Enum.map(coll, fun) |> Enum.filter(&(&1)) end)
  end

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
