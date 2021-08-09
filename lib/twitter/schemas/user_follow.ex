defmodule Twitter.Schemas.UserFollow do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.UUID

  alias Twitter.Schemas.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_fields [:from_id, :to_id]

  schema "user_follows" do
    belongs_to :from, User
    belongs_to :to, User

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_change(:from_id, &validate_uuid/2)
    |> validate_change(:to_id, &validate_uuid/2)
    |> check_constraint(:from_id, name: :from_and_to_cannot_be_equal)
    |> unique_constraint([:from_id, :to_id])
  end

  defp validate_uuid(field, uuid) do
    case UUID.cast(uuid) do
      :error -> [{field, "has invalid format"}]
      _ -> []
    end
  end
end
