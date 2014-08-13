defmodule TacoSmith.Markdown do

  def render(collection) do
    filter = ~r/\.(md|markdown)$/
    TacoSmith.process_each(collection, filter, &render_markdown/1)
  end

  def render_markdown(record = %TacoSmith.Content{}) do
    body = record.body |> Enum.join |> Earmark.to_html
    new_name = String.replace(record.info.path, Path.extname(record.info.path), ".html")
    info = Dict.put(record.info, :path, new_name)
    %TacoSmith.Content{ record | body: [body], info: info }
  end

end
