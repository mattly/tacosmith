defmodule TacoSmith.Utils do
  import String, only: [to_integer: 1]

  @date_pattern "(\\d{4})-(\\d{2})-(\\d{2})"

  @date_re Regex.compile!("^#{@date_pattern}$")

  @time_pattern "(\\d{2}):(\\d{2})"

  def date(str) do
    cond do
      match = Regex.run(@date_re, str) ->
        [_, y, m, d] = match
        to_date(y, m, d)

      match = Regex.run(~r/^#{@date_pattern}[ T]#{@time_pattern}$/, str) ->
        [_, y, m, d, h, mi] = match
        { to_date(y, m, d), to_time(h, mi, "0") }
    end
  end

  defp to_date(y, m, d), do: {to_integer(y), to_integer(m), to_integer(d)}

  defp to_time(h, m, s), do: {to_integer(h), to_integer(m), to_integer(s)}

end
