defmodule Twitter.UseCases.UnfollowUserTest do
  use Twitter.DataCase, async: true

  alias Twitter.UseCases.{CreateUser, FollowUser, UnfollowUser}

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

    test "when user_from does not follow user_to, return an error", %{
      user_one_id: user_one_id, user_two_id: user_two_id
    } do
      params = %{"from_id" => user_one_id, "to_id" => user_two_id}

      result = UnfollowUser.call(params)

      expected_result = {:error, %{detail: ["user follow not exists"]}}

      assert expected_result == result
    end

    test "when user_from follow user_to, return a :ok atom", %{
      user_one_id: user_one_id, user_two_id: user_two_id
    } do
      params = %{"from_id" => user_one_id, "to_id" => user_two_id}

      FollowUser.call(params)
      result = UnfollowUser.call(params)

      expected_result = :ok

      assert expected_result == result
    end

    test "when user_from follow user_to, unfollow user with sucess", %{
      user_one_id: user_one_id, user_two_id: user_two_id
    } do
      params = %{"from_id" => user_one_id, "to_id" => user_two_id}

      FollowUser.call(params)
      :ok = UnfollowUser.call(params)
      result = UnfollowUser.call(params)

      expected_result = {:error, %{detail: ["user follow not exists"]}}

      assert expected_result == result
    end
  end
end
