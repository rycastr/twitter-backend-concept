defmodule Twitter.UseCases.GetFollowers do
  import Ecto.Query

  alias Twitter.Schemas.{User, UserFollow}
  alias Twitter.Repo

  def call(params) do
    params
    |> build_query()
    |> Repo.all()
    |> Repo.preload(from: build_preload_query())
    |> extract_from()
    |> handle_followers()
    # |> Repo.preload([:from])
  end

  defp build_query(%{"to_id" => to_id}) do
    from(uf in UserFollow, where: uf.to_id == ^to_id)
  end

  defp build_preload_query() do
    from(u in User, select: map(u, [:id, :name, :username]))
  end

  defp extract_from(user_follows) do
    user_follows
    |> Enum.map(fn %UserFollow{from: from} -> from end)
  end

  defp handle_followers(followers) do
    {:ok, %{followers_count: length(followers), followers: followers}}
  end
end
