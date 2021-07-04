defmodule Twitter.UseCases.GetFollowingTest do
  use Twitter.DataCase, async: true

  alias Twitter.UseCases.{CreateUser, FollowUser, GetFollowing}

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

      # params_user_tree = %{
      #   "email" => "josephdoe@example.com",
      #   "name" => "Joseph",
      #   "username" => "josephdoe",
      #   "password" => "anypassword"
      # }

      {:ok, user_one} = CreateUser.call(params_user_one)
      {:ok, user_two} = CreateUser.call(params_user_two)
      # {:ok, user_tree} = CreateUser.call(params_user_tree)

      FollowUser.call(%{"from_id" => user_two.id, "to_id" => user_one.id})
      # FollowUser.call(%{"from_id" => user_tree.id, "to_id" => user_one.id})

      %{
        user_one_id: user_one.id,
        user_two_id: user_two.id
        # user_tree_id: user_tree.id
      }
    end

    test "when the user does not follow anyone, returns a following empty list and following count 0",
         %{
           user_one_id: user_one_id
         } do
      params = %{"from_id" => user_one_id}

      {:ok, result} = GetFollowing.call(params)

      assert %{following: [], following_count: 0} = result
    end

    test "when the user follows someone, returns a following list and following count", %{
      user_two_id: user_two_id
    } do
      params = %{"from_id" => user_two_id}

      {:ok, %{following: following, following_count: following_count}} = GetFollowing.call(params)

      assert is_list(following) && is_integer(following_count)
    end

    test "when the user follows someone, returns a following count valid of list", %{
      user_two_id: user_two_id
    } do
      params = %{"from_id" => user_two_id}

      {:ok, %{following: following, following_count: following_count}} = GetFollowing.call(params)

      assert length(following) == following_count
    end
  end
end
