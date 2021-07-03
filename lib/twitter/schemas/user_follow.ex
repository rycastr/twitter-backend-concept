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
    |> unique_constraint([:from_id, :to_id])
  end

  defp validate_uuid(:from_id, uuid) do
    case Ecto.UUID.cast(uuid) do
      :error -> [from_id: "has invalid format"]
      _ -> []
    end
  end

  defp validate_uuid(:to_id, uuid) do
    case UUID.cast(uuid) do
      :error -> [to_id: "has invalid format"]
      _ -> []
    end
  end
end
