defmodule TacoSmith.EEx do
  defmodule Options, do: defstruct template_directory: "templates"

  def render(collection, options = %Options{})
  when is_list(collection) do
    filter = fn(doc) -> Dict.get(doc.info, :layout) end
    TacoSmith.process(collection, filter, &(render_document(&1, options)))
  end

  def render(collection, options = %{})
  when is_list(collection) do
    render(collection, struct(Options, options))
  end

  def render_document(doc = %TacoSmith.Content{}, options = %Options{}) do
    layout = Dict.get(doc.info, :layout, "default.html")
    context = Dict.merge(doc.info, %{content: Enum.join(doc.body)})
            |> Enum.into(Keyword.new)
    html = EEx.eval_file("#{Path.join(options.template_directory, layout)}.eex", context)
    %TacoSmith.Content{ doc | body: [html] }
  end

  def render_document(doc = %TacoSmith.Content{}, options = %{}) do
    render_document(doc, struct(Options, options))
  end

end

