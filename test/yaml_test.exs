defmodule YamlTest do
  use ExUnit.Case

  test "extracts YAML front-matter into %info" do
    record = TacoSmith.Content.create("test/source", "README.md")
    |> TacoSmith.YAML.process_frontmatter
    assert record.info.title == "Read Me"
    assert record.info.layout == "layout"
    assert record.info.published == true
    body = Enum.join(record.body)
    refute String.match?(body, ~r|---|)
    refute String.match?(body, ~r|layout|)
  end

end
