defmodule Twitter.UseCases.AuthenticateUserTest do
  use Twitter.DataCase, async: true

  alias Twitter.UseCases.AuthenticateUser

  describe "call/1" do
    test "when email field not exists, returns an error" do
      params = %{"email" => "any@mail.com", "password" => "anypassword"}

      result = AuthenticateUser.call(params)

      expected_result = {:error, %{email: ["email not exists"]}}

      assert expected_result == result
    end

    test "when username field not exists, returns an error" do
      params = %{"username" => "any_username", "password" => "anypassword"}

      result = AuthenticateUser.call(params)

      expected_result = {:error, %{username: ["username not exists"]}}

      assert expected_result == result
    end

    test "when password field is incorrect, returns an error" do
      params = %{"username" => "johndoe", "password" => "incorrect_password"}

      Twitter.UseCases.CreateUser.call(%{
        "email" => "johndoe@example.com",
        "name" => "John",
        "username" => "johndoe",
        "password" => "a1s2d3$4"
      })

      result = AuthenticateUser.call(params)

      expected_result = {:error, %{password: ["incorrect password"]}}

      assert expected_result == result
    end

    test "when email and password fields there are correct, returns a user" do
      params = %{"email" => "johndoe@example.com", "password" => "a1s2d3$4"}

      Twitter.UseCases.CreateUser.call(%{
        "email" => "johndoe@example.com",
        "name" => "John",
        "username" => "johndoe",
        "password" => "a1s2d3$4"
      })

      result = AuthenticateUser.call(params)

      assert {:ok,
              %Twitter.Schemas.User{
                email: "johndoe@example.com",
                name: "John",
                username: "johndoe"
              }} = result
    end

    test "when username and password fields there are correct, returns a user" do
      params = %{"username" => "johndoe", "password" => "a1s2d3$4"}

      Twitter.UseCases.CreateUser.call(%{
        "email" => "johndoe@example.com",
        "name" => "John",
        "username" => "johndoe",
        "password" => "a1s2d3$4"
      })

      result = AuthenticateUser.call(params)

      assert {:ok,
              %Twitter.Schemas.User{
                email: "johndoe@example.com",
                name: "John",
                username: "johndoe"
              }} = result
    end
  end
end
