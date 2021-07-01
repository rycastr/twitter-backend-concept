defmodule Twitter.Repo.Migrations.CreateTableUsers do
  use Ecto.Migration

  def change do
    create table :users do
      add :email, :string
      add :name, :string
      add :username, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
  end
end
