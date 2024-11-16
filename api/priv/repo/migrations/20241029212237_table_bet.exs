defmodule Betty.Repo.Migrations.TableBet do
  use Ecto.Migration

  def change do
   create table("bet") do
      add :value, :float
      add :odd, :float
      add :description, :string
      add :bet_type, :integer
    end
  end
end
