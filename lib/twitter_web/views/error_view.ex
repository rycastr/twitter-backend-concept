defmodule TwitterWeb.ErrorView do
  use TwitterWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def render("400.json", %{result: %Ecto.Changeset{} = changeset}) do
    %{
      errors: translate_errors(changeset)
    }
  end

  def render("400.json", %{result: result}) do
    %{
      errors: result
    }
  end

  def render("500.json", _result) do
    %{
      errors: %{
        detail: "Internal Server Error"
      }
    }
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
