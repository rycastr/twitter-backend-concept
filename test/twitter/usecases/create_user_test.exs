defmodule Twitter.UseCases.CreateUserTest do
  use Twitter.DataCase, async: true

  alias Twitter.Repo
  alias Twitter.Schemas.User
  alias Twitter.UseCases.CreateUser

  describe "call/1" do
    test "when any field is missing returns changeset error" do
      params = %{
        name: "John",
        username: "johndoe",
        password: "anypassword"
      }

      result = CreateUser.call(params)

      assert {:error, %Ecto.Changeset{}} = result
    end

    test "when any field is invalid, returns changeset error" do
      params = %{
        email: "invalid_email",
        name: "John",
        username: "johndoe",
        password: "anypassword"
      }

      result = CreateUser.call(params)

      assert {:error, %Ecto.Changeset{}} = result
    end

    test "when there all params are valid, returns an user from database" do
      params = %{
        email: "johndoe@example.com",
        name: "John",
        username: "johndoe",
        password: "anypassword"
      }

      {:ok, %User{id: user_id}} = CreateUser.call(params)
      user = Repo.get(User, user_id)

      assert %User{
               email: "johndoe@example.com",
               name: "John",
               username: "johndoe"
             } = user
    end
  end
end
