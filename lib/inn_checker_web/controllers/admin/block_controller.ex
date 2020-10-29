defmodule InnCheckerWeb.Admin.BlockController do
  use InnCheckerWeb, :controller

  # alias InnChecker.Inn
  alias InnChecker.Checker.Helper
  alias InnChecker.Blocker.Block

  action_fallback InnCheckerWeb.FallbackController

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    result_redis = Block.list_block()
    block_list = Enum.chunk_every(result_redis, 2)
    block_map = Enum.map(block_list, fn x ->
      [ip | [timestamp]] = x
      %{ip: ip, timestamp: timestamp}
    end)
    # IO.inspect(block_map)
    with :ok <- Bodyguard.permit(InnChecker.Blocker.Policy, :block_area, current_user, block_list) do
      render(conn, "index.html", block_list: block_map)
    end
  end

  #%{"block" => block_params}
  def create(conn, %{"block_ip" => block_params}, current_user) do

    with :ok <- Bodyguard.permit(InnChecker.Blocker.Policy, :block_area, current_user, block_params) do
      case Block.insert_block(Helper.now_plus_timestamp(block_params["timestamp"]), block_params["ip_address"]) do
        1 ->
          conn
          |> put_flash(:info, "IP адрес заблокирован")
          |> redirect(to: Routes.admin_block_path(conn, :index))
        0 ->
          conn
          |> put_flash(:error, "Такой IP адрес уже заблокирован")
          |> redirect(to: Routes.admin_block_path(conn, :index))
        _ ->
          conn
          |> put_status(403)
          |> put_layout(false)
          |> render(InnCheckerWeb.ErrorView, "403.html")
      end
    end
  end

  def delete(conn, %{"id" => ip_address}, current_user) do
    get_ip_timestamp = Block.check_block(ip_address)

    if get_ip_timestamp != nil do
      with :ok <- Bodyguard.permit(InnChecker.Blocker.Policy, :block_area, current_user, ip_address) do
        Block.delete_block(ip_address)
        conn
        |> put_flash(:info, "IP адрес разблокирован")
        |> redirect(to: Routes.admin_block_path(conn, :index))
      end
    end

  end
end
