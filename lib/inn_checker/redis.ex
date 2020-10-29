defmodule InnChecker.Redis do

  use GenServer
  require Logger

  @check_interval 60 * 1000
  @block_table "block_ips"

  # REDIX CONFIG
	@host Application.get_env(:inn_checker, :redis_host)
	@port Application.get_env(:inn_checker, :redis_port)
	# @database Application.get_env(:inn_checker, :redis_database)
	@password Application.get_env(:inn_checker, :redis_password)
	@name Application.get_env(:inn_checker, :redis_name)

  '''
  alias InnChecker.Redis
  {:ok, pid} = Redis.start_link
  Redis.check(pid)
  '''

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(init_arg) do
    Redix.start_link(
      host: @host,
      port: @port,
      password: @password,
      name: @name
    )
    schedule_work()
    {:ok, init_arg}
  end

  # CLIENT

  def check() do
    GenServer.call(__MODULE__, :check)
  end

  def add(groupset, timestamp, value) do
    GenServer.call(__MODULE__, {:add, groupset, timestamp, value})
  end

  def get(groupset, from, to) do
    GenServer.call(__MODULE__, {:get, groupset, from, to})
  end

  def remove(groupset, value) do
    GenServer.call(__MODULE__, {:remove, groupset, value})
  end

  def get_all(groupset) do
    # proc = Process.whereis(:redix)
    GenServer.call(__MODULE__, {:get, groupset, "+inf", "-inf"})
  end

  def check_exist(groupset, value) do
    GenServer.call(__MODULE__, {:check_exist, groupset, value})
  end



  # SERVER

  def handle_info(:work, state) do
    unix_tsmp = DateTime.utc_now() |> DateTime.to_unix
    unblock_ips = get_ips_by_timestamp(unix_tsmp, 1)
    # IO.inspect(unblock_ips)
    Enum.map(unblock_ips, fn ip ->
      unblock_ip(ip)
      Logger.info("#{ip} Unblock.", ansi_color: :green)
    end)

    Logger.info("Check block IP. Access app at http://localhost:4000", ansi_color: :green)

    schedule_work()

    {:noreply, state}
  end

  def handle_call(:check, _from, state) do
    func = Redix.command!(@name, ["PING"])
    {:reply, func, state}
  end

  def handle_call({:add, groupset, timestamp, value}, _from, state) do
    func = Redix.command!(@name, ["ZADD", groupset, timestamp, value])
    {:reply, func, state}
  end

  def handle_call({:get, groupset, from, to}, _from, state) do
    func = Redix.command!(@name, ["ZREVRANGEBYSCORE", groupset, from, to, "WITHSCORES"])
    {:reply, func, state}
  end

  def handle_call({:remove, groupset, value}, _from, state) do
    func = Redix.command!(@name, ["ZREM", groupset, value])
    {:reply, func, state}
  end

  def handle_call({:check_exist, groupset, value}, _from, state) do
    func = Redix.command!(@name, ["ZSCORE", groupset, value])
    {:reply, func, state}
  end


  ### PRIVATE

  defp schedule_work() do
    Process.send_after(self(), :work, @check_interval)
  end

  defp get_ips_by_timestamp(from, to) do
    func = Redix.command!(@name, ["ZREVRANGEBYSCORE", @block_table, from, to])
    func
  end

  defp unblock_ip(value) do
    func = Redix.command!(@name, ["ZREM", @block_table, value])
    func
  end


end
