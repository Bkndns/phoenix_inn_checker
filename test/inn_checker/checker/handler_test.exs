defmodule InnChecker.Checker.HandlerTest do
  use ExUnit.Case, async: true

  alias InnChecker.Checker.Handler

  describe "Функция проверки ИНН" do

    test "check_inn empty" do
      assert Handler.check("") == false
    end

    test "check_inn" do
      assert Handler.check(7830002293) == true
      assert Handler.check(5032111175) == true
      assert Handler.check(7707083893) == true
      assert Handler.check(7325144248) == true
      assert Handler.check(7830002590) == true
      assert Handler.check(4543543543) == true
      assert Handler.check(500100732259) == true
      assert Handler.check(325507450247) == true
      assert Handler.check(773006366201) == true
      assert Handler.check(771472033358) == true
      refute Handler.check(781633333333) == true
      refute Handler.check(0) == true
    end

    test "check_inn_10" do
      assert Handler.check10num(7830002293) == true
      assert Handler.check10num(5032111175) == true
      assert Handler.check10num(7707083893) == true
      assert Handler.check10num(7325144248) == true
      assert Handler.check10num(7830002590) == true
      assert Handler.check10num(4543543543) == true
      refute Handler.check(0) == true
    end

    test "check_inn_12" do
      assert Handler.check12num(500100732259) == true
      assert Handler.check12num(325507450247) == true
      assert Handler.check12num(773006366201) == true
      assert Handler.check12num(771472033358) == true
      refute Handler.check12num(781633333333) == true
      refute Handler.check(0) == true
    end

  end


end
