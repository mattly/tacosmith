# TacoSmith

A static site generator written in Elixir, inspired by
[MetalSmith](http://www.metalsmith.io/), which in turn is inspired by
[WinterSmith](http://wintersmith.io).

    INT. LOFT APARTMENT, EVENING

    A man sits at a laptop computer, staring.  Frustrated with the state of his
    existing tools for creating static sites, the yak shaving he's going to
    have to do to get the toolchain working on his new laptop (pandoc: install
    GHC, which on Mavericks requires a non-clang gcc; among others), he decides
    to start anew.  He remembers that **Functional Programming** is about data
    manipulation and that's exactly what a static site generator needs.  This
    man is MATTHEW LYON.  He realizes he needs a name for the new project, and
    is stumped.  He calls to his wife, ALYSSA, who is upstairs posting cat
    pictures to reddit:

                MATTHEW
        Hon, I need a name for a proj--

                ALYSSA
        Taco.

                MATTHEW
        But, that doens't even--

                ALYSSA
        Taco.

                MATTHEW
        That's what I called the last one!

                ALYSSA
        I *said* taco!

    Thinking, he types `mix new tacosmith`.

Still very much a work in progress, it will render markdown to html, but
the templating is still coming together and there aren't "collections"
yet.

An example of how you might use it in its current form:

`build.exs`:
``` elixir
TacoSmith.read("source")
|> TacoSmith.YAML.frontmatter   # Extracts YAML metadata from Markdown files
|> TacoSmith.Markdown.render    # Renders Markdown to HTML, changes file name
|> TacoSmith.EEx.render         # Renders from {layout}.html.eex templates in "templates" dir
|> TacoSmith.write(%{dest: "build"})
```
