defmodule InnChecker.Blocker.BlockTest do
  use ExUnit.Case, async: true

  # alias InnChecker.Helper
  # alias InnChecker.Redis
  alias InnChecker.Blocker.Block

  @block_table "block_ips_test"

  setup do
    on_exit(fn ->
      all_redis = Block.list_block(@block_table)
      Enum.map(all_redis, fn x ->
        Block.delete_block(x, @block_table)
      end)
    end)
  end

  def redis_fixture(tstmp \\ 1603894374, ip \\ "192.168.0.1") do
    Block.insert_block(tstmp, ip, @block_table)
  end

  describe "Функции блокировки IP" do

    test "Block list_block" do
      redis_fixture()
      redis_fixture(1603894378, "192.168.0.99")
      assert Block.list_block(@block_table) == ["192.168.0.99", "1603894378", "192.168.0.1", "1603894374"]
    end

    test "Block insert_block" do
      func = Block.insert_block(1504005000, "192.190.90.10", @block_table)
      assert func == 1
    end

    test "Block delete_block" do
      redis_fixture()
      check = Block.delete_block("192.168.0.1", @block_table)
      assert check == 1
      get_all = Block.list_block(@block_table)
      assert get_all == []
    end

    test "Block check_block" do
      redis_fixture()
      check = Block.check_block("192.168.0.1", @block_table)
      assert check == "1603894374"
    end

    test "Block check_block nil" do
      redis_fixture()
      check = Block.check_block("192.168.99.99", @block_table)
      assert check == nil
    end

  end

end
