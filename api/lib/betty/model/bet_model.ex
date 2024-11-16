defmodule Betty.Lib.Models.BetModel do
  @typedoc """
  """
  @type t :: %__MODULE__{
          value: Float.t(),
          odd: Float.t(),
          description: String.t(),
          bet_type: Integer.t()
        }

  @enforce_keys [:value, :odd, :bet_type]
  defstruct value: 0,
            odd: 0.0,
            description: "",
            bet_type: 1

  @entry_types %{
    :back => 1,
    :lay => 2
  }

  def new(attributes), do: {:ok, struct!(__MODULE__, attributes)}

  def get_entry_type(key), do: Map.get(@entry_types, key)
end
