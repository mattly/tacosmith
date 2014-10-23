defmodule TacoSmith.EEx do

  def context_for_doc(doc, site) do
    %{ page: doc.info, site: site, content: Enum.join(doc.body) }
  end

  defmodule Options do
    defstruct template_directory: "templates",
              context: &TacoSmith.EEx.context_for_doc/2
  end

  alias TacoSmith.Site
  alias TacoSmith.Content

  def render(site = %Site{}, options = %Options{}) do
    filter = fn(doc) -> Dict.get(doc.info, :layout) end
    TacoSmith.process(site, filter, &(render_document(&1, site, options)))
  end

  def render(site = %Site{}, options = %{}) do
    render(site, struct(Options, options))
  end

  def render_document(doc = %Content{}, site = %Site{}, options = %Options{}) do
    layout = Dict.get(doc.info, :layout, "default.html")
    context = options.context.(doc, site) |> Enum.into(Keyword.new)
    html = EEx.eval_file("#{Path.join(options.template_directory, layout)}.eex", context)
    %Content{ doc | body: [html] }
  end

  def render_document(doc = %Content{}, site = %Site{}, options = %{}) do
    render_document(doc, site, struct(Options, options))
  end


end

