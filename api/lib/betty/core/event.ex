defmodule Betty.Core.Event do
  alias Betty.Repo
  alias Betty.Schemas.EventSchema

  def create(data) do
    data
    |> EventSchema.changeset()
    |> Repo.insert()
  end

  def get_all() do
    Repo.all(EventSchema) 
    |> Repo.preload([:participants])
  end

  def get(uuid) do
    Repo.get_by(EventSchema, [uuid: uuid])
    |> Repo.preload([:participants])
  end
end
