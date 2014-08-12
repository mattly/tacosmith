defmodule TacoSmith.Content do
  @derive Access
  defstruct source: "", output: true, info: %{}, body: [], stat: nil
  @type t :: %TacoSmith.Content{source: String.t, output: boolean, info: Map.t, body: Enumerable.t, stat: File.Stat.t}

  def create(dir, path) when is_binary(path) do
    filepath = Path.join(dir, path)
    %TacoSmith.Content{source: filepath, info: %{path: path}, body: File.stream!(filepath), stat: File.stat!(filepath)}
  end

end

