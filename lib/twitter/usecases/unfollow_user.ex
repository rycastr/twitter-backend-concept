defmodule Twitter.UseCases.UnfollowUser do
  import Ecto.Query

  alias Twitter.Repo
  alias Twitter.Schemas.UserFollow

  def call(params) do
    params
    |> build_query()
    |> Repo.delete_all()
    |> handle_delete()
  end

  defp build_query(%{"from_id" => from_id, "to_id" => to_id}) do
    from(UserFollow, where: [from_id: ^from_id, to_id: ^to_id])
  end

  defp handle_delete({0, nil}), do: {:error, %{detail: ["user follow not exists"]}}

  defp handle_delete({1, nil}), do: :ok
end
