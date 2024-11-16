defmodule Betty.Repo do
  use Ecto.Repo,
    otp_app: :betty,
    adapter: Ecto.Adapters.Postgres

  alias Ecto.Changeset

  def insert_with_validation(changeset) do
    case changeset do
      %Changeset{valid?: true} ->
          insert(changeset)
      %Changeset{valid?: false} ->
          {:error, changeset}
    end
  end
end
