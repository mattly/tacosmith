defmodule CollectionTest do
  use ExUnit.Case

  test "creates a collection" do
    site = TacoSmith.read("test/source")
    |> TacoSmith.Collection.define :markdowns, ~r{[^/]\.md$}, {nil, true}
    assert site.collections.markdowns
    collection_docs = TacoSmith.Collection.manifest(site, :markdowns)
    assert ["another.md", "README.md"] == Enum.map(collection_docs, &(&1.info.path))
  end

end
