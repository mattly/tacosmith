defmodule TacoSmithTest do
  use ExUnit.Case

  test "listing the source directory" do
    records = TacoSmith.list "test/source"
    files = Path.wildcard("./test/source/**")
    |> Enum.filter(&File.regular?/1)
    |> Enum.map(&(String.replace(&1, "./test/source/", "")))
    assert length(records) == length(files)
    Enum.zip(files, records)
    |> Enum.each(fn({path, record}) ->
      assert "./test/source" == record.dir
      assert path == record.source
      assert path == record.dest
      filepath = "./test/source/#{path}"
      assert filepath == TacoSmith.Content.filepath(record)
      assert File.stat!(filepath) == TacoSmith.Content.stat(record)
      assert File.read!(filepath) == Enum.join(TacoSmith.Content.stream(record))
    end)
  end

end
