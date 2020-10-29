defmodule InnCheckerWeb.Admin.UserView do
  use InnCheckerWeb, :view

  @select_data [
    "5 минут": 300,
    "10 минут": 600,
    "30 минут": 1800,
    "1 час": 3600,
    "2 часа": 7200,
    "3 часа": 10800,
  ]

  def get_select_data() do
    @select_data
  end
end
