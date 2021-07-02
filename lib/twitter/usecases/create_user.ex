defmodule Twitter.UseCases.CreateUser do
  alias Twitter.Schemas.User
  alias Twitter.Repo

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end
end
