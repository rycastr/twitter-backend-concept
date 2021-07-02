defmodule TwitterWeb.UsersController do
  use TwitterWeb, :controller

  alias Twitter.Schemas.User
  alias Twitter.UseCases.{AuthenticateUser, CreateUser}

  action_fallback TwitterWeb.FallbackController

  def register(conn, params) do
    with {:ok, user} <- CreateUser.call(params),
         {:ok, token, _claims} <- sign(user) do
      conn
      |> put_status(:created)
      |> render("created.json", result: %{access_token: token})
    end
  end

  def auth(conn, params) do
    with {:ok, user} <- AuthenticateUser.call(params),
         {:ok, token, _claims} <- sign(user) do
      conn
      |> put_status(:ok)
      |> render("authenticated.json", result: %{access_token: token})
    end
  end

  defp sign(%User{id: user_id, username: username}) do
    TwitterWeb.Token.generate_and_sign(%{
      user_id: user_id,
      username: username
    })
  end
end
