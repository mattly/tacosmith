defmodule MarkdownTest do
  use ExUnit.Case

  test "converts markdown to html" do
    docs = TacoSmith.list("test/source")
    |> TacoSmith.YAML.frontmatter
    |> TacoSmith.Markdown.render
    readme = Enum.find(docs, &(&1.info.path == "README.html"))
    assert readme
    assert readme.body |> Enum.join |> String.match?(~r|<h1>|)
  end

end
