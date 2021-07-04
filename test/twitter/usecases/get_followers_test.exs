defmodule Twitter.UseCases.GetFollowersTest do
  use Twitter.DataCase, async: true

  alias Twitter.UseCases.{CreateUser, FollowUser, GetFollowers}

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

    test "when the user has no followers, returns a followers empty list and followers count 0",
         %{
           user_two_id: user_two_id
         } do
      params = %{"to_id" => user_two_id}

      {:ok, result} = GetFollowers.call(params)

      assert %{followers: [], followers_count: 0} = result
    end

    test "when the user has followers, returns a followers list and followers count", %{
      user_one_id: user_one_id
    } do
      params = %{"to_id" => user_one_id}

      {:ok, %{followers: followers, followers_count: followers_count}} = GetFollowers.call(params)

      assert is_list(followers) && is_integer(followers_count)
    end

    test "when the user has followers, returns a followers count valid of list", %{
      user_one_id: user_one_id
    } do
      params = %{"to_id" => user_one_id}

      {:ok, %{followers: followers, followers_count: followers_count}} = GetFollowers.call(params)

      assert length(followers) == followers_count
    end
  end
end
