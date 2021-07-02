defmodule TwitterWeb.UsersView do
  def render("created.json", %{result: result}) do
    %{
      result: result
    }
  end
end
