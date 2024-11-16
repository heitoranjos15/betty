defmodule Betty.Schemas.EventSchema do
  alias Ecto.Changeset
  use Ecto.Schema

  @fields [:start_date]
  @primary_key {:uuid, Ecto.UUID, autogenerate: true}

  schema "event" do
    field(:start_date, :utc_datetime)

    many_to_many(:participants, Betty.Schemas.TeamSchema,
      join_through: "event_participants",
      join_keys: [event_uuid: :uuid, team_uuid: :uuid]
    )

    timestamps()
  end

  def changeset(data) do
    %__MODULE__{}
    |> Changeset.cast(data, @fields)
    |> Changeset.cast_assoc(
      :participants,
      require: true
    )
    |> Changeset.validate_required(@fields)
  end
end
