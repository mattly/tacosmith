defmodule TacoSmith.EEx do
  defmodule Options, do: defstruct template_directory: "templates"
  alias TacoSmith.Site
  alias TacoSmith.Content

  def render(site = %Site{}, options = %Options{}) do
    filter = fn(doc) -> Dict.get(doc.info, :layout) end
    TacoSmith.process(site, filter, &(render_document(&1, options)))
  end

  def render(site = %Site{}, options = %{}) do
    render(site, struct(Options, options))
  end

  def render_document(doc = %Content{}, options = %Options{}) do
    layout = Dict.get(doc.info, :layout, "default.html")
    context = Dict.merge(doc.info, %{content: Enum.join(doc.body)})
            |> Enum.into(Keyword.new)
    html = EEx.eval_file("#{Path.join(options.template_directory, layout)}.eex", context)
    %Content{ doc | body: [html] }
  end

  def render_document(doc = %Content{}, options = %{}) do
    render_document(doc, struct(Options, options))
  end

end

