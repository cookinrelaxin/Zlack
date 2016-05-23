defmodule Zlack.Session do
  alias Zlack.{Repo, User}

  def authenticate(%{"username" => username, "password" => password}) do
    user = Repo.get_by(User, username: username)

    case check_password(user, password) do
      true -> {:ok, user}
      _ -> :error
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> Comeonin.Bcrypt.dummy_checkpw()
      _ -> Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
    end
  end
end

