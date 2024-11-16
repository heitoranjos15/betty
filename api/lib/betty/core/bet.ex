defmodule Betty.Lib.Core.Bet do
  alias Betty.Lib.Models.BetModel

  def new(attributes) do
    BetModel.new(attributes)
  end
end
