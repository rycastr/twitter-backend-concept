defmodule Twitter.Repo.Migrations.CreateContraintUserFollows do
  use Ecto.Migration

  def change do
    create constraint(:user_follows, :from_and_to_cannot_be_equal, check: "from_id != to_id")
  end
end
