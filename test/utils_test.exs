defmodule TacoSmithUtilsTest do
  use ExUnit.Case
  alias TacoSmith.Utils

  test "converts date strings to Date tuples" do
    assert {2014, 1, 1} == Utils.date("2014-01-01")
  end

  test "converts datetime strings to {Date, Time}" do
    assert {{2014, 10, 20}, {13, 14, 0}} == Utils.date("2014-10-20 13:14")
    # assert {{2014, 10, 20}, {13, 14, 0}} == Utils.date("2014-10-20T13:14")
  end

end
