defmodule Betty.Schemas.BetSchema do
  alias Ecto.Changeset
  use Ecto.Schema

  @fields [:value, :odd, :description, :bet_type]

  schema "bet" do
    field(:value, :float)
    field(:odd, :float)
    field(:description, :string)
    field(:bet_type, :integer)
  end

  def changeset(attributes) do
    %__MODULE__{}
    |> Changeset.cast(attributes, @fields)
    |> Changeset.validate_required(@fields)
  end
end
