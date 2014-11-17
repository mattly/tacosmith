defmodule TacoSmith.Collection do
  defstruct name: :pages, filter: ~r/./, sort: "", reverse: false

  alias TacoSmith.Site
  alias TacoSmith.Collection

  def define(site=%Site{}, name, filter=%Regex{})
  when is_atom(name) do
    define site, name, filter, &(&1.info.path), false
  end

  def define(site=%Site{}, name, filter=%Regex{}, sort)
  when is_atom(name)
  and is_function(sort) do
    define site, name, filter, sort, false
  end

  def define(site=%Site{}, name, filter, sort)
  when is_atom(name)
  and is_function(filter)
  and is_function(sort) do
    define site, name, filter, sort, false
  end

  def define(site=%Site{}, name, filter=%Regex{}, sort, reverse)
  when is_atom(name)
  and is_function(sort)
  and is_boolean(reverse) do
    filter_fn = &(Regex.match?(filter, &1.info.path))
    define site, name, filter_fn, sort, reverse
  end

  def define(site=%Site{}, name, filter, sort, reverse)
  when is_atom(name)
  and is_function(filter)
  and is_function(sort)
  and is_boolean(reverse) do
    collection = %Collection{name: name, filter: filter, sort: sort, reverse: reverse}
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
