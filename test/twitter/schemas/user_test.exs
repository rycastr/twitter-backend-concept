defmodule Twitter.Schemas.UserTest do
  use Twitter.DataCase, async: true

  alias Twitter.Schemas.User

  describe "changeset/1" do
    test "when the email field is missing, returns changeset error" do
      params = %{
        name: "John",
        username: "johndoe",
        password: "anypassword"
      }

      result = User.changeset(params)

      expected_result = %{
        email: ["can't be blank"]
      }

      assert errors_on(result) == expected_result
    end

    test "when the username field is missing, returns changeset error" do
      params = %{
        name: "John",
        email: "johndoe@example.com",
        password: "anypassword"
      }

      result = User.changeset(params)

      expected_result = %{
        username: ["can't be blank"]
      }

      assert errors_on(result) == expected_result
    end

    test "when the name field is missing, returns changeset error" do
      params = %{
        username: "johndoe",
        email: "johndoe@example.com",
        password: "anypassword"
      }

      result = User.changeset(params)

      expected_result = %{
        name: ["can't be blank"]
      }

      assert errors_on(result) == expected_result
    end

    test "when the password field is missing, returns changeset error" do
      params = %{
        username: "johndoe",
        email: "johndoe@example.com",
        name: "John"
      }

      result = User.changeset(params)

      expected_result = %{
        password: ["can't be blank"]
      }

      assert errors_on(result) == expected_result
    end

    test "when the password field contains less than 8 characters, returns changeset error" do
      params = %{
        email: "johndoe@example.com",
        name: "John",
        username: "johndoe",
        password: "any"
      }

      result = User.changeset(params)

      expected_result = %{
        password: ["should be at least 8 character(s)"]
      }

      assert errors_on(result) == expected_result
    end

    test "when the email field is incorrectly formatted, returns changeset error" do
      params = %{
        email: "johnexample.com",
        name: "John",
        username: "johndoe",
        password: "anypassword"
      }

      result = User.changeset(params)

      expected_result = %{
        email: ["has invalid format"]
      }

      assert errors_on(result) == expected_result
    end

    test "when all fields are correct, returns changeset with valid password_hash" do
      params = %{
        email: "john@example.com",
        name: "John",
        username: "johndoe",
        password: "anypassword"
      }

      %Ecto.Changeset{
        valid?: true,
        changes: %{
          password_hash: password_hash
        },
        errors: []
      } = User.changeset(params)

      assert Bcrypt.verify_pass(params.password, password_hash)
    end

    test "when all fields are correct, returns a valid changeset" do
      params = %{
        email: "john@example.com",
        name: "John",
        username: "johndoe",
        password: "anypassword"
      }

      result = User.changeset(params)

      assert %Ecto.Changeset{
               valid?: true,
               changes: %{
                 name: "John",
                 email: "john@example.com"
               },
               errors: []
             } = result
    end
  end
end
