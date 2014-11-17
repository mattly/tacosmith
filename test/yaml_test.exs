defmodule YamlTest do
  use ExUnit.Case

  test "extracts YAML front-matter into %info" do
    record = TacoSmith.Content.create("test/source", "README.md")
    |> TacoSmith.YAML.process_frontmatter
    assert record.info.title == "Read Me"
    assert record.info.layout == "default.html"
    assert record.info.published == true
    body = Enum.join(record.body)
    refute String.match?(body, ~r|---|)
    refute String.match?(body, ~r|default|)
  end

  test "processes frontmatter from collection" do
    site = TacoSmith.read("test/source")
    |> TacoSmith.YAML.frontmatter
    readme = Enum.find(site.files, &(&1.info.path == "README.md"))
    assert readme
    assert readme.info.title == "Read Me"
    assert readme.info.layout == "default.html"
  end

  test "processes sidecar files" do
    site = TacoSmith.read("test/source")
    |> TacoSmith.YAML.sidecar
    another = Enum.find(site.files, &(&1.info.path == "another.md"))
    assert another
    assert another.info.title == "Another"
    assert another.info.layout == "default.html"
    refute another.info.published
  end

  test "converts dates from frontmatter" do
    site = TacoSmith.read("test/source")
    |> TacoSmith.YAML.frontmatter
    doc = Enum.find(site.files, &(&1.info.path == "articles/a_second.md"))
    assert doc
    assert doc.info.date == Timex.Date.from({2014, 11, 3})
  end

end
