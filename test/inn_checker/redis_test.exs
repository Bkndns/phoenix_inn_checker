defmodule InnChecker.RedisTest do
  use ExUnit.Case, async: true

  # alias InnChecker.Helper
  alias InnChecker.Redis

  @block_table "block_ips_test"

  setup do
    on_exit(fn ->
      all_redis = Redis.get_all(@block_table)
      Enum.map(all_redis, fn x ->
        Redis.remove(@block_table, x)
      end)
    end)
  end

  def redis_fixture(tstmp \\ 1603894374, ip \\ "192.168.0.1") do
    Redis.add(@block_table, tstmp, ip)
  end

  test "Redis Check" do
    check = Redis.check()
    assert check == "PONG"
  end

  test "Redis Add" do
    check = Redis.add(@block_table, 1603894374, "192.168.0.2")
    assert check == 1
  end

  test "Redis Get" do
    redis_fixture()
    check = Redis.get(@block_table, 1603913037, 1603894370)
    assert check == ["192.168.0.1", "1603894374"]
  end

  test "Redis Get All" do
    redis_fixture()
    redis_fixture(1603894378, "192.168.0.99")
    check = Redis.get_all(@block_table)
    assert check == ["192.168.0.99", "1603894378", "192.168.0.1", "1603894374"]
  end

  test "Redis Remove Test" do
    redis_fixture()
    check = Redis.remove(@block_table, "192.168.0.1")
    assert check == 1
    get_all = Redis.get_all(@block_table)
    assert get_all == []
  end

  test "Redis Check Exist Test" do
    redis_fixture()
    check = Redis.check_exist(@block_table, "192.168.0.1")
    assert check == "1603894374"
  end

end
