defmodule TacoSmith.Markdown do

  def render(collection), do: render(collection, %Earmark.Options{})

  def render(collection, earmark_options = %Earmark.Options{}) do
    filter = ~r/\.(md|markdown)$/
    TacoSmith.process(collection, filter, &(render_record(&1, earmark_options)))
  end

  def render_record(record = %TacoSmith.Content{}), do: render_record(record, %Earmark.Options{})

  def render_record(record = %TacoSmith.Content{}, earmark_options = %Earmark.Options{}) do
    body = record.body |> Enum.join |> Earmark.to_html(earmark_options)
    new_name = String.replace(record.info.path, Path.extname(record.info.path), ".html")
    info = Dict.put(record.info, :path, new_name)
    %TacoSmith.Content{ record | body: [body], info: info }
  end

end
