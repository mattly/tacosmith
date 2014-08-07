defmodule TacoSmith.Tasks.Build do

  def run(args) do
    [source|args] = args
    [dest|_args] = args
    TacoSmith.clean(dest)
    TacoSmith.list(source)
    |> Enum.each fn (listing) ->
      IO.puts("#{listing.dest}: #{TacoSmith.Content.stat(listing).size}")
      # File.open!("./content/#{listing.source}", [:read, :utf8], fn(infile) ->
      #   File.open!("./build/#{listing.destination}", [:write, :utf8], fn(outfile) ->
      #     IO.write(outfile, IO.read(infile, :line))
      #   end)
      # end)
    end
  end
end
