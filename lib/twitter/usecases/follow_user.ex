defmodule Twitter.UseCases.FollowUser do
  def call(params) do
    params
    |> Twitter.Schemas.UserFollow.changeset()
    |> Twitter.Repo.insert()
  end
end
