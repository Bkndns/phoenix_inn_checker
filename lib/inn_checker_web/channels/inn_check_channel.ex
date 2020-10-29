defmodule InnCheckerWeb.InnCheckChannel do
  use InnCheckerWeb, :channel

  alias InnChecker.Inn
  alias InnChecker.Checker.Handler
  alias InnChecker.Checker.Helper
  alias InnChecker.Blocker.Block


  @impl true
  def join("inn_check:lobby", _payload, socket) do
    {:ok, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (inn_check:lobby).
  @impl true
  def handle_in("check_inn", payload, socket) do
    ip_address = get_ip_socket_address(socket)

    if payload["inn"] != "" and is_binary(payload["inn"]) do

      inn_num_digest = String.length(payload["inn"])
      inn = String.to_integer(payload["inn"])

      if inn > 0 and (inn_num_digest >= 10) and (inn_num_digest <= 12)  do

        data = return_first_check_data(inn, ip_address)

        # Block Redis Check
        check_ip_block(socket, ip_address, data)

      else
        broadcast(socket, "check_inn", %{error: "Invalid input data"})

        {:noreply, socket}
        # {:reply, :ok, socket}
      end

    else
      broadcast(socket, "check_inn", %{error: "empty_inn"})

      {:noreply, socket}
      # {:reply, :ok, socket}
    end

  end


  # PRIVATE

  defp get_ip_socket_address(socket) do
    # ip_address = socket.assigns.ip_address.peer_data.address |> :inet.ntoa() |> to_string()
    ip_address = Helper.get_user_ip(socket)
    ip_address
  end

  defp return_first_check_data(inn, ip_address) do
    # API
    check_inn_api = Handler.check(inn)
    data = %{inn: inn, status: check_inn_api, ip: ip_address}
    data
  end

  defp check_block_datetime(timestamp, data, socket) do
    unix_time = String.to_integer(timestamp)
    if (DateTime.utc_now() |> DateTime.to_unix) > unix_time do
      Block.delete_block(data.ip)
      # Разблокировали и добавляем ИНН
      insert_inn(socket, data)
      {:noreply, socket}
    else
      broadcast(socket, "check_inn", %{error: "Ошибка, ваш IP временно заблокирован. Повторите попытку позже."})
      {:noreply, socket}
    end
  end

  defp check_ip_block(socket, ip_address, data) do
    timestamp = Block.check_block(ip_address)
    if timestamp != nil do
      check_block_datetime(timestamp, data, socket)
    else
      insert_inn(socket, data)
    end
  end

  defp insert_inn(socket, data) do
    insert = Inn.create_history(data)

    inserted_at = case insert do
      {:ok, %InnChecker.Inn.History{inserted_at: inserted_at}} -> inserted_at
      {:error, err_body} -> err_body.errors
    end

    data = %{inn: data.inn, ip: data.ip, status: Helper.prepate_status(data.status), inserted_at: Helper.prepare_date(inserted_at)}
    IO.inspect(data)

    broadcast(socket, "check_inn", data)

    {:noreply, socket}
  end


end
