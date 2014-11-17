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
    published = &( String.match?(&1.info.path, ~r{^articles/.+\.md$}) )
    sort = &(Timex.Date.to_secs(&1.info.date))
    site = TacoSmith.read("test/source")
    |> TacoSmith.YAML.frontmatter       # parse the date strings from frontmatter
    |> TacoSmith.Collection.define :articles, published, sort, true
    assert site.collections.articles
    articles = TacoSmith.Collection.manifest(site, :articles)

    paths = ["articles/third.md", "articles/a_second.md", "articles/the_first.md"]
    assert paths == Enum.map(articles, &(&1.info.path))
  end

end
