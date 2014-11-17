defmodule TacoSmith.Content do
  @derive Access
  defstruct source: "", output: true, info: %{}, body: [], stat: nil
  @type t :: %TacoSmith.Content{
    source: String.t,
    output: boolean,
    info: Map.t,
    body: Enumerable.t,
    stat: File.Stat.t
  }

  def create(dir, path) when is_binary(path) do
    filepath = Path.join(dir, path)
    body = File.stream!(filepath)
    stat = File.stat!(filepath)
    info = %{ path: path, date: Timex.Date.from(stat.mtime) }
    %TacoSmith.Content{source: filepath, info: info, body: body, stat: stat}
  end

end

