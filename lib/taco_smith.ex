defmodule TacoSmith do

  defmodule Site, do: defstruct files: [], info: %{}, source: ""

  defp pmap(coll, fun) do
    Enum.map(coll, fn(item) -> Task.async(fn -> fun.(item) end) end)
    |> Enum.map(&Task.await/1)
  end

  def read(source) do
    files = Path.wildcard("./#{source}/**")
    |> Enum.filter(&File.regular?/1)
    |> Enum.map(&(String.replace(&1, "./#{source}/", "")))
    |> Enum.map(&(TacoSmith.Content.create("./#{source}", &1)))
    %Site{ files: files, source: source }
  end

  def process(site = %Site{}, filter = %Regex{}, fun)
  when is_function(fun) do
    process(site, &(Regex.match?(filter, &1.info.path)), fun)
  end

  def process(site = %Site{}, filter_fun, process_fun)
  when is_function(filter_fun)
  and is_function(process_fun) do
    {matches, rest} = Enum.partition(site.files, filter_fun)
    files = pmap(matches, process_fun)
    |> Enum.filter(&(&1))
    |> Enum.concat(rest)
    %Site{ site | files: files }
  end

  def process(site = %Site{}, fun)
  when is_function(fun), do: process(site, fn(_) -> true end, fun)

  def clean(dest) do
    File.rm_rf "./#{dest}"
    File.mkdir "./#{dest}"
  end

  def write(site = %Site{}, config = %{}) do
    clean(config.dest)
    site.files
    |> Enum.each fn(doc) ->
      filepath = Path.join(config.dest, doc.info.path)
      dir = Path.dirname(filepath)
      if dir != '.' && ! File.exists?(dir), do: File.mkdir_p!(dir)
      File.write!(filepath, Enum.join(doc.body))
    end
    :ok
  end

end
