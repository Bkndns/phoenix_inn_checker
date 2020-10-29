defmodule InnChecker.Checker.HandlerSupervisor do

  use Supervisor

	def start_link([]) do
		Supervisor.start_link(__MODULE__, [])
	end

	def init(_) do
		children = [
			worker(InnChecker.Checker.Handler, [])
		]

		supervise(children, strategy: :one_for_one)
	end

end
