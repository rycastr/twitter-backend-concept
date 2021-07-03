defmodule Twitter.Repo.Migrations.CreateUserFollowsTable do
  use Ecto.Migration

  def change do
    create table :user_follows do
      add :from_id, references(:users)
      add :to_id, references(:users)

      timestamps()
    end

    create unique_index(:user_follows, [:from_id, :to_id])
  end
end
