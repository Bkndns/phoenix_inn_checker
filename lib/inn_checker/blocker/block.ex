defmodule InnChecker.Blocker.Block do

  # alias InnChecker.Users.User
  alias InnChecker.Redis

  @redis_dataset "block_ips"

  def list_block(table \\ @redis_dataset) do
    Redis.get_all(table)
  end

  def insert_block(timestamp_plus, ip_address, table \\ @redis_dataset) do
    Redis.add(table, timestamp_plus, ip_address)
  end

  def delete_block(ip_address, table \\ @redis_dataset) do
    Redis.remove(table, ip_address)
  end

  def check_block(ip_address, table \\ @redis_dataset) do
    # return Timestamp or Nil
    Redis.check_exist(table, ip_address)
  end

end
