defmodule CjkDoubleStroke.Application do
  use Application

  def start(_type, _args) do
    children = []

    opts = [strategy: :one_for_one, name: CjkDoubleStroke.Supervisor]
    result = Supervisor.start_link(children, opts)

    # Load the in-memory database synchronously so it is ready
    # when iex -S mix returns control to the user.
    CjkDoubleStroke.Datagenerators.StaticData.init()

    result
  end
end
