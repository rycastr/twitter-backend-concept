defmodule Twitter.UseCases.AuthenticateUser do
  alias Twitter.Schemas.User

  def call(%{"password" => password} = params) do
    params
    |> find_by()
    |> auth(password)
  end

  defp find_by(%{"email" => email}) do
    case Twitter.Repo.get_by(User, email: email) do
      nil -> {:error, %{email: ["email not exists"]}}
      user = %User{} -> {:ok, user}
    end
  end

  defp find_by(%{"username" => username}) do
    case Twitter.Repo.get_by(User, username: username) do
      nil -> {:error, %{username: ["username not exists"]}}
      user = %User{} -> {:ok, user}
    end
  end

  defp auth({:ok, %User{password_hash: password_hash} = user}, password) do
    case Bcrypt.verify_pass(password, password_hash) do
      false -> {:error, %{password: ["incorrect password"]}}
      true -> {:ok, user}
    end
  end

  defp auth({:error, reason}, _password), do: {:error, reason}
end
