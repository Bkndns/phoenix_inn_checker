defmodule InnChecker.Checker.Helper do

  use Timex

  def prepare_date(date_from_db) do
    date_time = Timex.to_datetime(date_from_db, "Europe/Ulyanovsk")
    # timezone = Timezone.get("Europe/Ulyanovsk", Timex.now)
    {:ok, datetime} = DateTime.from_naive(date_time, "Etc/UTC")
    start_date = NaiveDateTime.to_string(datetime)

    date_time =
      start_date
        |> Timex.parse!("%Y-%m-%d %H:%M:%S", :strftime)
        |> Timex.format!("%d.%m.%Y %H:%M", :strftime)

    # "#{datetime.day}.#{datetime.month}.#{datetime.year} #{datetime.hour}:#{datetime.minute}"
    date_time
  end

  def prepare_timestamp(timestamp) do
    timestamp = String.to_integer(timestamp)
    {:ok, datetime} = DateTime.from_unix(timestamp)
    # IO.inspect(datetime)
    prepare_date(datetime)
  end

  def now_plus_timestamp(timestamp) do
    timestamp = if is_binary(timestamp) do
      String.to_integer(timestamp)
    else
      timestamp
    end

    return =
      DateTime.utc_now()
      |> DateTime.to_unix
      |> Kernel.+(timestamp)

    return
  end

  def prepate_status(status_form_db) do
    if status_form_db == true, do: "корректен", else: "некорректен"
  end

  def get_user_ip(conn) do
    forwarded_for = List.first(Plug.Conn.get_req_header(conn, "x-forwarded-for"))

    if forwarded_for do
      String.split(forwarded_for, ",")
      |> Enum.map(&String.trim/1)
      |> List.first()
    else
      conn.remote_ip |> :inet.ntoa() |> to_string()
    end
  end

  def get_ip_address(%{x_headers: headers_list}) do
    header = Enum.find(headers_list, fn {key, _val} -> key == "x-real-ip" end)

    case header do
      nil -> nil
      {_key, value} -> value
      _ -> nil
    end
  end

  def get_ip_address(_) do
    nil
  end


end
