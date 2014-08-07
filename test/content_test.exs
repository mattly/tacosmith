defmodule TacoSmithContentTest do
  use ExUnit.Case

  test "adding metadata to a Content" do
    content = TacoSmith.Content.create("./test/source", "README.md")
    |> TacoSmith.Content.append_metadata(%{title: "Readme"})
    assert content.metadata.title == "Readme"
    assert %TacoSmith.Content{} = content
  end

  test "processors" do
    content = TacoSmith.Content.create("./test/source", "README.md")
            |> TacoSmith.Content.append_processor(fn(e, _) -> Stream.map(e, &String.upcase/1) end)

    assert 1 == Enum.count content.processors
    result = TacoSmith.Content.process(content)
    expected = File.read!("./test/source/README.md") |> String.upcase
    assert expected == result
  end
end
