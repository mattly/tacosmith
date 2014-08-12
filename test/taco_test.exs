defmodule TacoSmithTest do
  use ExUnit.Case

  setup context do
    if dir = context[:clean] do
      File.rm_rf dir
      on_exit fn -> File.rm_rf dir end
    end

    files = Path.wildcard("./test/source/**")
    |> Enum.filter(&File.regular?/1)
    { :ok, files: files }
  end

  test "listing the source directory", context do
    records = TacoSmith.list "test/source"
    files = context[:files]
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

  test "process with a regex filter", context do
    files = context[:files]
    |> Enum.filter(&(! String.match?(&1, ~r|mix\.exs$|)))
    records = TacoSmith.list("test/source")
    |> TacoSmith.process(~r|mix\.exs$|, fn(_) -> [] end)
    assert length(files) == length(records)
    Enum.zip(files, records)
    |> Enum.each(fn({path, record}) -> assert path == record.source end)
  end

  test "processing each with a regex filter", context do
    files = context[:files]
    |> Enum.filter(&(! String.match?(&1, ~r|mix\.exs$|)))
    records = TacoSmith.list("test/source")
    |> TacoSmith.process_each(~r|mix\.exs$|, fn(_) -> nil end)
    assert length(files) == length(records)
    Enum.zip(files, records)
    |> Enum.each(fn({path, record}) -> assert path == record.source end)
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
