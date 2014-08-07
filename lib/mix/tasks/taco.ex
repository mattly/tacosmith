defmodule Mix.Tasks.Taco do
  use Mix.Task

  def run(args) do
    opts = OptionParser.parse(args)
    case elem(opts, 1) do
      [] -> raise Mix.Error, message: "expected COMMAND"
      [cmd|tail] ->
        valid = Enum.any?(["build"], &(&1 == cmd))
        unless valid do raise Mix.Error, message: "the cmd `#{cmd}` is not known" end
        case cmd do
          "build" -> TacoSmith.Tasks.Build.run(tail)
        end
    end
  end

end
