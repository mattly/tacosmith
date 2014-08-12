defmodule TacoSmith.Tasks.Build do

  def run(args) do
    [source|args] = args
    [dest|_args] = args
    TacoSmith.clean(dest)
    TacoSmith.list(source)
    |> Enum.each fn (listing) ->
      IO.puts("#{listing.dest}: #{TacoSmith.Content.stat(listing).size}")
    end
  end
end
