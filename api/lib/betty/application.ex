defmodule Betty.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Betty.Repo,
      {Registry, [keys: :unique, name: Betty.EventRegistry]},
      Betty.Boundary.EventSupervisor
    ]

    opts = [strategy: :one_for_one, name: Betty.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
