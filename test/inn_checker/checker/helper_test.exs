defmodule InnChecker.Checker.HelperTest do
  use ExUnit.Case, async: true

  #alias InnChecker.Checker.Handler
  alias InnChecker.Checker.Helper

  test "Prepare date" do
    assert Helper.prepare_date(~N[2020-10-24 14:48:57]) == "24.10.2020 14:48"
  end

  test "Prepare status" do
    assert Helper.prepate_status(true) == "корректен"
    assert Helper.prepate_status(false) == "некорректен"
  end

  test "Timestamp Plus now Function" do
    timestamp = 1000
    assert Helper.now_plus_timestamp(timestamp) == DateTime.utc_now() |> DateTime.to_unix |> Kernel.+(timestamp)
  end

  test "Timestamp Plus now Function Timestamp String" do
    timestamp = "1000"
    tstmp = String.to_integer(timestamp)
    assert Helper.now_plus_timestamp(timestamp) == DateTime.utc_now() |> DateTime.to_unix |> Kernel.+(tstmp)
  end

end
