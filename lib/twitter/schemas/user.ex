defmodule Twitter.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  # alias Twitter.Schemas.UserFollow

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_fields [:email, :name, :username, :password]

  schema "users" do
    field :email, :string
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    # has_many :following, UserFollow, foreign_key: :from_id
    # has_many :followers, UserFollow, foreign_key: :to_id

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:password, min: 8)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint([:email])
    |> unique_constraint([:username])
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp hash_password(changeset), do: changeset
end
