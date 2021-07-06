defmodule Twitter.UseCases.GetFollowing do
  import Ecto.Query

  alias Twitter.Schemas.{User, UserFollow}
  alias Twitter.Repo

  def call(params) do
    params
    |> build_query()
    |> Repo.all()
    |> Repo.preload(to: build_preload_query())
    |> Enum.map(&get_to/1)
    |> handle_followers()
    # |> Repo.preload([:from])
  end

  defp build_query(%{"from_id" => from_id}) do
    from(uf in UserFollow, where: uf.from_id == ^from_id)
  end

  defp build_preload_query() do
    from(u in User, select: map(u, [:id, :name, :username]))
  end

  defp get_to(%UserFollow{to: to}), do: to

  defp handle_followers(followers) do
    {:ok, %{following_count: length(followers), following: followers}}
  end
end
