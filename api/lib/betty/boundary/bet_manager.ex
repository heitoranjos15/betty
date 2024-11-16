defmodule Betty.Boundary.BetManager do
  use GenServer

  alias Betty.Repo
  alias Betty.Lib.Core.Bet
  alias Betty.Schemas.BetSchema

  def start_link(event) do
    GenServer.start_link(__MODULE__, event, name: server(event.uuid))
  end

  defp server(pid) when is_pid(pid), do: pid

  defp server(event) do
    {:via, Registry, {Betty.EventRegistry, event}}
  end

  def save(event, data) do
    GenServer.call(server(event), {:save, data})
  end

  def list(event) do
    GenServer.call(server(event), {:list})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:save, data}, _from, state) do
    bet = Bet.new(data)

    data
    |> BetSchema.changeset()
    |> Repo.insert()


    {:reply, :ok, [bet | state]}
  end

  def handle_call({:list}, _from, state) do
    {:reply, state, state}
  end
end
