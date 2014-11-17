defmodule TacoSmith.Utils do
  import String, only: [to_integer: 1]

  use Timex

  @date_format  "\\d{4}-\\d{1,2}-\\d{1,2}"
  @date_regex   Regex.compile!("^#{@date_format}$")
  @time_24h     Regex.compile!("^#{@date_format} \\d{1,2}:\\d{2}$")

  def date(str) do
    cond do
      Regex.run(@date_regex, str) -> DateFormat.parse!(str, "{YYYY}-{M}-{D}")
      Regex.run(@time_24h, str) -> DateFormat.parse!(str, "{YYYY}-{M}-{D} {h24}:{m}")
    end
  end

end
