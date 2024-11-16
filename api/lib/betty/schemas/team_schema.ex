defmodule Betty.Schemas.TeamSchema do
  alias Ecto.Changeset
  use Ecto.Schema

  @fields [:name, :sport]
  @primary_key {:uuid, Ecto.UUID, autogenerate: true}

  schema "team" do
    # field(:name, :string)
    field(:sport, :string)
    timestamps()
  end

  def changeset(data) do
    %__MODULE__{}
    |> Changeset.cast(data, @fields)
    |> Changeset.validate_required(@fields)
  end
end
