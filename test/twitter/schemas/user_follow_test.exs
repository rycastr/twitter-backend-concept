defmodule Twitter.Schemas.UserFollowTest do
  use Twitter.DataCase, async: true

  alias Twitter.Schemas.UserFollow
  alias Twitter.UseCases.CreateUser

  describe "changeset/1" do
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

    test "when the from_id field is missing, returns an changeset error", %{
      user_two_id: user_two_id
    } do
      params = %{"to_id" => user_two_id}

      result = UserFollow.changeset(params)

      expected_result = %{from_id: ["can't be blank"]}

      assert errors_on(result) == expected_result
    end

    test "when the to_id field is missing, returns an changeset error", %{
      user_one_id: user_one_id
    } do
      params = %{"from_id" => user_one_id}

      result = UserFollow.changeset(params)

      expected_result = %{to_id: ["can't be blank"]}

      assert errors_on(result) == expected_result
    end

    test "when the from_id field is invalid, returns an changeset error", %{
      user_two_id: user_two_id
    } do
      params = %{"from_id" => "any", "to_id" => user_two_id}

      result = UserFollow.changeset(params)

      expected_result = %{from_id: ["has invalid format"]}

      assert errors_on(result) == expected_result
    end

    test "when the to_id field is invalid, returns an changeset error", %{
      user_one_id: user_one_id
    } do
      params = %{"from_id" => user_one_id, "to_id" => "any"}

      result = UserFollow.changeset(params)

      expected_result = %{to_id: ["has invalid format"]}

      assert errors_on(result) == expected_result
    end

    test "when all fields there are valid, returns a changeset valid", %{
      user_one_id: user_one_id,
      user_two_id: user_two_id
    } do
      params = %{"from_id" => user_one_id, "to_id" => user_two_id}

      result = UserFollow.changeset(params)

      assert %Ecto.Changeset{
               valid?: true,
               changes: %{from_id: ^user_one_id, to_id: ^user_two_id},
               errors: []
             } = result
    end
  end
end
