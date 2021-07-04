defmodule Twitter.UseCases.GetFollowers do
  import Ecto.Query

  alias Twitter.Schemas.{User, UserFollow}
  alias Twitter.Repo

  def call(%{"to_id" => to_id}) do
    from(uf in UserFollow, where: uf.to_id == ^to_id)
    |> Twitter.Repo.all()
    |> Repo.preload(from: from(u in User, select: map(u, [:id, :name, :username])))
    |> Enum.map(&get_from/1)
    |> handle_followers()
    # |> Twitter.Repo.preload([:from])
  end

  defp get_from(%UserFollow{from: from}), do: from

  defp handle_followers(followers) do
    {:ok, %{followers_count: length(followers), followers: followers}}
  end
end
