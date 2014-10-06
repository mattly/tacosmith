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
    site = TacoSmith.read "test/source"
    files = context[:files]
          |> Enum.map(&(String.replace(&1, "./test/source/", "")))
    assert length(site.files) == length(files)
    Enum.zip(files, site.files)
    |> Enum.each(fn({path, doc}) ->
      assert "./test/source/#{path}" == doc.source
      assert path == doc.info.path
      filepath = "./test/source/#{path}"
      assert File.stat!(filepath) == doc.stat
      assert File.read!(filepath) == Enum.join(doc.body)
    end)
  end

  test "processing with a regex filter", context do
    files = context[:files]
    |> Enum.filter(&(! String.match?(&1, ~r|mix\.exs$|)))
    site = TacoSmith.read("test/source")
    |> TacoSmith.process(~r|mix\.exs$|, fn(_) -> nil end)
    assert length(files) == length(site.files)
    Enum.zip(files, site.files)
    |> Enum.each(fn({path, doc}) -> assert path == doc.source end)
  end

  test "processing with a function filter", context do
    files = context[:files]
    |> Enum.filter(&( ! String.match?(&1, ~r|mix\.exs$|) ))
    site = TacoSmith.read("test/source")
    |> TacoSmith.process(&( String.match?(&1.info.path, ~r|mix\.exs$|) ), fn(_) -> nil end)
    assert length(files) == length(site.files)
    Enum.zip(files, site.files)
    |> Enum.each(fn({path, doc}) -> assert path == doc.source end)
  end

  @tag clean: "./test/dest"
  test "saving the collection" do
    dest = "test/dest"
    assert ! File.exists?(dest)
    site = TacoSmith.read("test/source")
    :ok = TacoSmith.write(site, %{dest: dest})
    assert File.exists?(dest)
    assert File.dir?(dest)
    Enum.each(site.files, fn(doc) ->
      assert File.exists?(Path.join(dest, doc.info.path))
    end)
  end

end
