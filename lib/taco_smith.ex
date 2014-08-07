defmodule TacoSmith do

  def list(source) do
    Path.wildcard("./#{source}/**")
    |> Enum.filter(&File.regular?/1)
    |> Enum.map(&(String.replace(&1, "./#{source}/", "")))
    |> Enum.map(&(TacoSmith.Content.create("./#{source}", &1)))
  end

  def clean(dest) do
    File.rm_rf "./#{dest}"
    File.mkdir "./#{dest}"
  end
end
