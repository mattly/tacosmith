defmodule EExTest do
  use ExUnit.Case

  test "renders record with default variable positions" do
    record = %TacoSmith.Content{ info: %{ title: "Document" }, body: ["Content goes here"] }
    |> TacoSmith.EEx.render_document(%{template_directory: "test/templates"})
    body = Enum.join(record.body)
    assert String.match?(body, ~r|<article>|)
    assert String.match?(body, ~r|<h1>#{record.info.title}|)
    assert String.match?(body, ~r|Content goes here|)
  end

  test "renders a collection with a filter on layout key" do
    docs = TacoSmith.list("test/source")
    |> TacoSmith.YAML.frontmatter
    |> TacoSmith.Markdown.render
    |> TacoSmith.EEx.render(%{template_directory: "test/templates"})
    readme = Enum.find(docs, &(&1.info.path == "README.html"))
    assert readme
    body = Enum.join(readme.body)
    assert String.match?(body, ~r|<article>|)
    assert String.match?(body, ~r|<h1>#{readme.info.title}</h1>|)
    assert String.match?(body, ~r|<h1>Taco</h1>|)
  end
end
