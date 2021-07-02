defmodule TwitterWeb.UsersControllerTest do
  use TwitterWeb.ConnCase, async: true

  alias Twitter.Repo
  alias Twitter.Schemas.User

  describe "register/2" do
    test "when all params are valid, create a new user", %{conn: conn} do
      params = %{
        "email" => "johndoe@example.com",
        "name" => "John",
        "username" => "johndoe",
        "password" => "anypassword"
      }

      conn
      |> post(Routes.users_path(conn, :register), params)
      |> json_response(:created)

      result = Repo.get_by(User, email: params["email"])

      assert %User{} = result
    end

    test "when all params are valid, returns a valid access_token", %{conn: conn} do
      params = %{
        "email" => "johndoe@example.com",
        "name" => "John",
        "username" => "johndoe",
        "password" => "anypassword"
      }

      %{"result" => %{"access_token" => access_token}} =
        conn
        |> post(Routes.users_path(conn, :register), params)
        |> json_response(:created)

      assert {:ok, %{"aud" => "Joken"}} = TwitterWeb.Token.verify(access_token)
    end
  end
end
