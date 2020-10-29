defmodule InnChecker.Checker.Handler do

  use GenServer

  @moduledoc """
  Модуль, который высчитывает валидность ИНН
  """

  '''
  alias InnChecker.Checker.Handler
  Handler.check(7830002293)

  Process.whereis(InnChecker.Checker.Handler) |> Process.exit(:exit)

  7830002293
  5032111175
  7707083893
  7325144248
  4543543543
  1212334455
  1231233332
  7830002590 - 10!

  500100732259
  325507450247
  773006366201
  771472033358
  781633333333 false
  '''

  ### GenServer API

  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_call({:check, inn_number}, _from, state) do
    func = _check(inn_number)
    {:reply, func, state}
  end

  def handle_call({:check10num, inn_number}, _from, state) do
    func = _check10num(inn_number)
    {:reply, func, state}
  end

  def handle_call({:check12num, inn_number}, _from, state) do
    func = _check12num(inn_number)
    {:reply, func, state}
  end





  ### Клиентский API
  def start_link(state \\ []) do
		GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def check(inn_number) do
    GenServer.call(__MODULE__, {:check, inn_number})
  end
  def check10num(inn_number) do
    GenServer.call(__MODULE__, {:check10num, inn_number})
  end
  def check12num(inn_number) do
    GenServer.call(__MODULE__, {:check12num, inn_number})
  end





  ### PRIVATE FUNCTIONS

  def _check(inn_number) do
    if inn_number == 0 do
      false
    else
      str_inn = to_string(inn_number)
      inn_num_digest = String.length(str_inn)
      if (inn_num_digest == 10) or (inn_num_digest == 12) do
        if inn_num_digest == 10, do: _check10num(inn_number), else: _check12num(inn_number)
      else
        false
      end
    end
  end

  def _check10num(inn_number) when inn_number > 0 do
    pattern = [2, 4, 10, 3, 5, 9, 4, 6, 8]
    check_inn_algo(inn_number, pattern, 10, 9)
  end

  def _check12num(inn_number) when inn_number > 0 do
    pattern = [7, 2, 4, 10, 3, 5, 9, 4, 6, 8]

    pattern_2 = [3, 7, 2, 4, 10, 3, 5, 9, 4, 6, 8]

    check_part_one = check_inn_algo(inn_number, pattern, 12, 10)

    # # # # #

    if check_part_one do
      check_inn_algo(inn_number, pattern_2, 12, 11)
    else
      false
    end
  end

  defp check_inn_algo(inn_number, pattern, how_much_inn, how_much_pop) do

    get_numbers = get_inn_numbers_in_list(inn_number, [], how_much_inn)

    {control_digest, num_list} = List.pop_at(get_numbers, how_much_pop)

    ziplist = Enum.zip(num_list, pattern)

    multiplication_list = Enum.map(ziplist, fn tuple ->
      {x, mn} = tuple
      x * mn
    end)

    summa_list = Enum.sum(multiplication_list)

    # diver_multi = trunc(summa_list / 11) * 11
    # difference = summa_list - diver_multi

    difference = rem(summa_list, 11)

    difference = if difference == 10, do: 0, else: difference

    check = if difference == control_digest, do: true, else: false

    check
  end

  defp get_inn_numbers_in_list(inn, collector, n) when n <= 1 do
    [inn | collector]
  end

  defp get_inn_numbers_in_list(inn, collector, n) do
    head = rem(inn, 10)
    tail = div(inn, 10)
    collector = [head | collector]
    get_inn_numbers_in_list(tail, collector, n - 1)
  end

end
