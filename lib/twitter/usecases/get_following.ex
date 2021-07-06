defmodule Twitter.UseCases.GetFollowing do
  import Ecto.Query

  alias Twitter.Schemas.{User, UserFollow}
  alias Twitter.Repo

  def call(%{"from_id" => from_id}) do
    from(uf in UserFollow, where: uf.from_id == ^from_id)
    |> Twitter.Repo.all()
    |> Repo.preload(to: from(u in User, select: map(u, [:id, :name, :username])))
    |> Enum.map(&get_to/1)
    |> handle_followers()
    # |> Twitter.Repo.preload([:from])
  end

  defp get_to(%UserFollow{to: to}), do: to

  defp handle_followers(followers) do
    {:ok, %{following_count: length(followers), following: followers}}
  end
end
