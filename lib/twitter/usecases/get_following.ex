defmodule Twitter.UseCases.GetFollowing do
  import Ecto.Query

  alias Twitter.Schemas.{User, UserFollow}
  alias Twitter.Repo

  def call(params) do
    params
    |> build_query()
    |> Repo.all()
    |> Repo.preload(to: build_preload_query())
    |> extract_to()
    |> handle_followers()
    # |> Repo.preload([:from])
  end

  defp build_query(%{"from_id" => from_id}) do
    from(uf in UserFollow, where: uf.from_id == ^from_id)
  end

  defp build_preload_query do
    from(u in User, select: map(u, [:id, :name, :username]))
  end

  defp extract_to(user_follows) do
    user_follows
    |> Enum.map(fn %UserFollow{to: to} -> to end)
  end

  defp handle_followers(followers) do
    {:ok, %{following_count: length(followers), following: followers}}
  end
end
