defmodule TacoSmithTest do
  use ExUnit.Case

  setup context do
    if dir = context[:clean] do
      File.rm_rf dir
      on_exit fn -> File.rm_rf dir end
    end
    :ok
  end

  test "listing the source directory" do
    records = TacoSmith.list "test/source"
    files = Path.wildcard("./test/source/**")
    |> Enum.filter(&File.regular?/1)
    |> Enum.map(&(String.replace(&1, "./test/source/", "")))
    assert length(records) == length(files)
    Enum.zip(files, records)
    |> Enum.each(fn({path, record}) ->
      assert "./test/source/#{path}" == record.source
      assert path == record.info.path
      filepath = "./test/source/#{path}"
      assert File.stat!(filepath) == record.stat
      assert File.read!(filepath) == Enum.join(record.body)
    end)
  end

  @tag clean: "./test/dest"
  test "saving the collection" do
    dest = "test/dest"
    assert ! File.exists?(dest)
    records = TacoSmith.list("test/source")
    :ok = TacoSmith.write_all(records, %{dest: dest})
    assert File.exists?(dest)
    assert File.dir?(dest)
    Enum.each(records, fn(record) ->
      assert File.exists?(Path.join(dest, record.info.path))
    end)
  end

end
