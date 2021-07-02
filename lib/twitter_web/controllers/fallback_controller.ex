defmodule TwitterWeb.FallbackController do
  use TwitterWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(TwitterWeb.ErrorView)
    |> render("400.json", result: result)
  end

  def call(conn, {:error, result}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(TwitterWeb.ErrorView)
    |> render("500.json", result: result)
  end
end
