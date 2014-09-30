defmodule MarkdownTest do
  use ExUnit.Case

  test "converts markdown to html" do
    docs = TacoSmith.list("test/source")
    |> TacoSmith.YAML.frontmatter
    |> TacoSmith.Markdown.render(%Earmark.Options{footnotes: true})
    readme = Enum.find(docs, &(&1.info.path == "README.html"))
    assert readme
    body = Enum.join(readme.body)
    assert String.match?(body, ~r|<h1>|)
    assert String.match?(body, ~r|class="footnotes"|)
  end

end
