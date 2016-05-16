defmodule Zlack.RegistrationController  do
  use Zlack.Web, :controller

  alias Zlack.{Repo, User}

  plug :scrub_params, "user" when action in [:create]

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = user |> Guardian.encode_and_sign(:token)

        conn
        |> put_status(:created)
        |> render(Zlack.SessionView, "show.json", jwt: jwt, user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def delete(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    Repo.delete(Repo.get_by(User, email: user.email))
    conn
    |> put_status(:ok)
    |> render("delete.json")
  end
end
