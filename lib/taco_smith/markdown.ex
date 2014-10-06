defmodule TacoSmith.Markdown do
  alias TacoSmith.Site
  alias TacoSmith.Content

  def render(site = %Site{}), do: render(site, %Earmark.Options{})

  def render(site = %Site{}, earmark_options = %Earmark.Options{}) do
    filter = ~r/\.(md|markdown)$/
    TacoSmith.process(site, filter, &(render_record(&1, earmark_options)))
  end

  def render_record(record = %Content{}), do: render_record(record, %Earmark.Options{})

  def render_record(record = %Content{}, earmark_options = %Earmark.Options{}) do
    body = record.body |> Enum.join |> Earmark.to_html(earmark_options)
    new_name = String.replace(record.info.path, Path.extname(record.info.path), ".html")
    info = Dict.put(record.info, :path, new_name)
    %Content{ record | body: [body], info: info }
  end

end
