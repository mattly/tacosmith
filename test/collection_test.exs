defmodule CollectionTest do
  use ExUnit.Case

  test "creates a collection" do
    site = TacoSmith.read("test/source")
    |> TacoSmith.Collection.define :markdowns, ~r{^[^/]+\.md$}
    assert site.collections.markdowns
    collection_docs = TacoSmith.Collection.manifest(site, :markdowns)
    assert ["README.md", "another.md"] == Enum.map(collection_docs, &(&1.info.path))
  end

  test "collections sort by provided function" do
    site = TacoSmith.read("test/source")
    # |> TacoSmith.Collection.define :articles, &( &1.info.published && String.match?(&1.info.path, ~r{^/articles/.+\.md$}) )
  end

end
