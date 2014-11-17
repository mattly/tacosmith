defmodule TacoSmithUtilsTest do
  use ExUnit.Case

  use Timex
  alias TacoSmith.Utils

  test "converts date strings to Timex structs" do
    assert Date.from({2014, 1, 1}) == Utils.date("2014-1-1")
  end

  test "converts datetime strings to Timex Structs" do
    assert Date.from({{2014, 10, 20}, {13, 14, 0}}) == Utils.date("2014-10-20 13:14")
  end

end
