defmodule Twitter.UseCases.FollowUser do
  alias Twitter.Repo
  alias Twitter.Schemas.UserFollow

  def call(params) do
    params
    |> UserFollow.changeset()
    |> Repo.insert()
  end
end
