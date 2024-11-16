defmodule Betty.Repo.Migrations.Event do
  use Ecto.Migration

  def change do
    create table("event", primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :start_date, :utc_datetime
      timestamps()
    end
    create table("team", primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :sport, :string
      timestamps()
    end

    create table("event_participants") do
      add :event_uuid, references(:event, column: :uuid, type: :uuid)
      add :team_uuid, references(:team, column: :uuid, type: :uuid)
    end
  end
end
