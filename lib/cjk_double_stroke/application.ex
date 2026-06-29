defmodule CjkDoubleStroke.Application do
  use Application

  def start(_type, _args) do
    children = []

    opts = [strategy: :one_for_one, name: CjkDoubleStroke.Supervisor]
    result = Supervisor.start_link(children, opts)

    # Try to connect to the dedicated DB node (non-blocking).
    # If it fails, the first data access will give a clear error.
    CjkDoubleStroke.DBClient.connect()

    # Requires dedicated DB node (db@localhost) to be connected.
    # See DBClient and the README for the fast iteration workflow.
    CjkDoubleStroke.Datagenerators.StaticData.init()

    result
  end
end
