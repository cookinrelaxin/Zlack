defmodule Zlack.UserActions do

  alias Zlack.{User, Repo}
  import Ecto.Query, only: [from: 2]
  alias Ecto.Query

  @moduledoc """
    This module defines the real shit: the actions that mutate the state of the application, specifically regarding users. Authentication should not be performed here.
  """

  @doc """
    Take a given page number greater than or equal to zero and return at most 10 users per page from the DB.
  """
  def index(%{"page" => page}) do
    page = User |> Repo.paginate(page: page, page_size: 10)
  end

  @doc """
    Create a user with the given parameters and insert into the DB.
  """
  def create(%{
      :first_name => first_name,
      :last_name => last_name,
      :email => email,
      :password => password
  } = attributes) do
    changeset = User.changeset(%User{}, attributes)
    res = Repo.insert!(changeset)
    {:ok, res}
  end

  @doc """
    Retrieve a user from the database with the given id.
  """
  def show(%{"id" => id}) do
    Repo.get_by(User, %{:id => id})
  end

  @doc """
    Retrieve a user from the database with the given email address.
  """
  def show(%{"email" => email}) do
    Repo.get_by(User, %{:email => email})
  end

  @doc """
    Edit a user from the database with the given id, setting values in params to be the new values.
  """
  def update(%{"id" => id, "params" => params}) do
    nil
  end

  @doc """
    Delete a user from the database. This is obviously a destructive operation and will show no mercy. You have been warned.
  """
  def delete(%{"id" => id}) do
    nil
  end

end
