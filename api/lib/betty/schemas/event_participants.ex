defmodule Betty.Schemas.EventParticipants do
  alias Ecto.Changeset
  use Ecto.Schema

  @fields [:event_uuid, :team_uuid]

  schema "event_participants" do
    belongs_to :event_uuid, Betty.Schemas.EventSchema
    belongs_to :team_uuid, Betty.Schemas.TeamSchema
  end
end
