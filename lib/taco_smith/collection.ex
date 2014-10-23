defmodule TacoSmith.Collection do
  defstruct name: :pages, filter: ~r/./, sort: "", reverse: false

  alias TacoSmith.Site
  alias TacoSmith.Collection

  def define(site=%Site{}, name, filter = %Regex{}, sort)
  when is_atom(name) and is_tuple(sort) do
    filt = &(Regex.match?(filter, &1.info.path))
    sortFn = elem(sort, 0)
    if ! sortFn, do: sortFn = &(&1.info.path)
    reverse = elem(sort, 1)
    collection = %Collection{ name: name, filter: filt, sort: sortFn, reverse: reverse }
    put_in site.collections[name], collection
  end

  def manifest(site=%Site{}, name)
  when is_atom(name) do
    collection = site.collections[name]
    docs = site.files
    |> Enum.filter(collection.filter)
    |> Enum.sort_by(collection.sort)
    if collection.reverse, do: docs = Enum.reverse(docs)
    docs
  end
end
