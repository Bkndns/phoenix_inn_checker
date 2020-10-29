defmodule InnCheckerWeb.InnCheckChannelTest do
  use InnCheckerWeb.ChannelCase


  alias InnChecker.Blocker.Block
  @block_table "block_ips"
  @ip_address "127.0.0.1"

  def redis_fixture(tstmp \\ 1603894374, ip \\ "192.168.0.1") do
    Block.insert_block(tstmp, ip, @block_table)
  end

  setup do

    on_exit(fn -> Block.delete_block(@ip_address, @block_table) end)

    {:ok, _, socket} =
      InnCheckerWeb.UserSocket
      |> socket("user_id", %{ip_address: %{
          peer_data: %{address: {127, 0, 0, 1}, port: 59228, ssl_cert: nil},
          x_headers: []
        }
      })
      |> subscribe_and_join(InnCheckerWeb.InnCheckChannel, "inn_check:lobby")

    %{socket: socket}
  end

  test "check INN IP BAN IP on block list to inn_check:lobby", %{socket: socket} do
    redis_fixture(InnChecker.Checker.Helper.now_plus_timestamp("1000"), @ip_address)

    data = %{inn: "2344123322", status: false, ip: @ip_address}
    push(socket, "check_inn", data)

    assert_broadcast("check_inn", %{error: "Ошибка, ваш IP временно заблокирован. Повторите попытку позже."})
  end

  test "check INN empty string to inn_check:lobby", %{socket: socket} do
    data = %{inn: "", status: false, ip: @ip_address}
    push(socket, "check_inn", data)

    assert_broadcast("check_inn", %{error: "empty_inn"})
  end

  test "check INN broadcasts to inn_check:lobby", %{socket: socket} do
    data = %{inn: "123456789123", status: false, ip: @ip_address}
    push(socket, "check_inn", data)

    assert_broadcast("check_inn", data)
  end

  test "check INN 1 broadcasts to inn_check:lobby", %{socket: socket} do
    data = %{inn: "1", status: false, ip: @ip_address}
    push(socket, "check_inn", data)

    assert_broadcast("check_inn", %{error: "Invalid input data"})
  end

  test "check INN 0 broadcasts to inn_check:lobby", %{socket: socket} do
    data = %{inn: "0", status: false, ip: @ip_address}
    push(socket, "check_inn", data)

    assert_broadcast("check_inn", %{error: "Invalid input data"})
  end

  test "check INN  234 broadcasts to inn_check:lobby", %{socket: socket} do
    data = %{inn: "234", status: false, ip: @ip_address}
    push(socket, "check_inn", data)

    assert_broadcast("check_inn", %{error: "Invalid input data"})
  end

  test "check 10 INN 4543543543 True broadcasts to inn_check:lobby", %{socket: socket} do
    data = %{inn: "4543543543", status: true, ip: @ip_address}
    push(socket, "check_inn", data)

    assert_broadcast("check_inn", data)
  end

  test "check 12 INN 771472033358 True broadcasts to inn_check:lobby", %{socket: socket} do
    data = %{inn: "771472033358", status: true, ip: @ip_address}
    push(socket, "check_inn", data)

    assert_broadcast("check_inn", data)
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
