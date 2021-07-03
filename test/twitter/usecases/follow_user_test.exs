defmodule Twitter.UseCases.FollowUserTest do
  use Twitter.DataCase, async: true

  alias Twitter.Repo
  alias Twitter.Schemas.UserFollow
  alias Twitter.UseCases.{CreateUser, FollowUser}

  describe "call/1" do
    setup do
      params_user_one = %{
        "email" => "johndoe@example.com",
        "name" => "John",
        "username" => "johndoe",
        "password" => "anypassword"
      }

      params_user_two = %{
        "email" => "janedoe@example.com",
        "name" => "Jane",
        "username" => "janedoe",
        "password" => "anypassword"
      }

      {:ok, user_one} = CreateUser.call(params_user_one)
      {:ok, user_two} = CreateUser.call(params_user_two)

      %{user_one_id: user_one.id, user_two_id: user_two.id}
    end

    test "when any field is missing, returns an changeset error", %{
      user_one_id: user_one_id
    } do
      params = %{from_id: user_one_id}

      result = FollowUser.call(params)

      assert {:error,
              %Ecto.Changeset{
                errors: [to_id: {"can't be blank", [validation: :required]}]
              }} = result
    end

    test "when any field is invalid, returns an changeset error", %{
      user_one_id: user_one_id
    } do
      params = %{from_id: user_one_id, to_id: "invalid"}

      result = FollowUser.call(params)

      assert {:error,
              %Ecto.Changeset{
                errors: [to_id: {"has invalid format", []}]
              }} = result
    end

    test "when the follow already exists, returns an changeset error", %{
      user_one_id: user_one_id,
      user_two_id: user_two_id
    } do
      params = %{from_id: user_one_id, to_id: user_two_id}

      {:ok, _} = FollowUser.call(params)
      result = FollowUser.call(params)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  from_id:
                    {"has already been taken",
                     [constraint: :unique, constraint_name: "user_follows_from_id_to_id_index"]}
                ]
              }} = result
    end

    test "when all fields there are valid, returns a user_follow from database", %{
      user_one_id: user_one_id,
      user_two_id: user_two_id
    } do
      params = %{from_id: user_one_id, to_id: user_two_id}

      {:ok, %UserFollow{id: uf_id}} = FollowUser.call(params)
      user_follow = Repo.get(UserFollow, uf_id)

      assert %UserFollow{
               from_id: ^user_one_id,
               to_id: ^user_two_id
             } = user_follow
    end
  end
end
