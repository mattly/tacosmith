defmodule TacoSmith.Content do
  @derive Access
  defstruct dir: "", source: "", dest: "", output: true, metadata: %{}, processors: []
  @type t :: %TacoSmith.Content{dir: String.t, source: String.t, dest: String.t, output: boolean, metadata: Map.t, processors: list}

  def create(dir, path) when is_binary(path) do
    %TacoSmith.Content{dir: dir, source: path, dest: path}
  end

  def filepath(content = %TacoSmith.Content{}), do: Path.join(content.dir, content.source)

  def stat(content = %TacoSmith.Content{}), do: File.stat!(filepath(content))

  def stream(content = %TacoSmith.Content{source: source}) when source != "" do
    File.stream!(filepath(content))
  end

  def append_metadata(content = %TacoSmith.Content{}, new_pairs = %{}) do
    %TacoSmith.Content{ content | metadata: Map.merge(content.metadata, new_pairs) }
  end

  def append_processor(content = %TacoSmith.Content{processors: p}, fun) when is_function(fun) do
    %TacoSmith.Content{ content | processors: [ fun | p ] }
  end

  def process(content = %TacoSmith.Content{}) do
    content.processors
    |> Enum.reverse
    |> Enum.reduce(stream(content), fn(p, enum) -> p.(enum, content.metadata) end)
    |> Enum.join
  end

end

