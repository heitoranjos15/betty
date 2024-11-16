defmodule Betty.Boundary.EventSupervisor do
  use DynamicSupervisor
  alias Betty.Core.Event

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create_event(data) do
    Event.create(data)
  end

  def start_event(uuid) do
    event = Event.get(uuid)

    child_spec = %{
      id: uuid,
      start: {Betty.Boundary.BetManager, :start_link, [%{uuid: event.uuid}]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
