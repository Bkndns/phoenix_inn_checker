defmodule InnChecker.RedixSupervisor do
	use Supervisor

	# REDIX CONFIG
	@host Application.get_env(:inn_checker, :redis_host)
	@port Application.get_env(:inn_checker, :redis_port)
	@database Application.get_env(:inn_checker, :redis_database)
	@password Application.get_env(:inn_checker, :redis_password)
	@name Application.get_env(:inn_checker, :redis_name)

	@redix_url "redis://h:p3d58396416900fb1cbaa16337d7648243d0ee6e5ff2150b150bf4ab4041eea75@ec2-54-227-196-98.compute-1.amazonaws.com:25429"

	def start_link([]) do
		Supervisor.start_link(__MODULE__, [])
	end

	def init(_) do
		children = [
      worker(Redix, [[name: @name]])
      # worker(Redix, [[host: @host, port: @port, database: @database, password: @password, name: @name]])
		]

		supervise(children, strategy: :one_for_one)
	end


end
