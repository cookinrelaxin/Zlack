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
      :username => _username,
      :password => _password,
      :is_guest => _is_guest,
  } = attributes) do
    changeset = User.changeset(%User{}, attributes)
    res = Repo.insert!(changeset)
    {:ok, res}
  end

  @doc """
    Create a user with a randomly generated username.
  """
  def create(:guest) do
    username = random_username
    case show(%{"username" => username}) do
      nil -> create(%{username: username, password: "correct horse battery staple", is_guest: true})
      _ -> create(:guest)
    end
  end

  defp random_adverb do
    {:ok, query} = Ecto.Adapters.SQL.query(Repo, "select * from adverbs limit 1 offset floor(random() * (select count(*) from adverbs))", [])
    query.rows
    |> hd
    |> tl
    |> hd
  end

  defp random_adjective do
    {:ok, query} = Ecto.Adapters.SQL.query(Repo, "select * from adjectives limit 1 offset floor(random() * (select count(*) from adjectives))", [])
    query.rows
    |> hd
    |> tl
    |> hd
  end

  defp random_noun do
    {:ok, query} = Ecto.Adapters.SQL.query(Repo, "select * from nouns limit 1 offset floor(random() * (select count(*) from nouns))", [])
    query.rows
    |> hd
    |> tl
    |> hd
  end

  defp random_username do
    random_adverb <> "." <> random_adjective <> "." <> random_noun
  end

  @doc """
    Retrieve a user from the database with the given username.
  """
  def show(%{"id" => id}) do
    Repo.get_by(User, %{:id => id})
  end

  @doc """
    Retrieve a user from the database with the given username address.
  """
  def show(%{"username" => username}) do
    Repo.get_by(User, %{:username => username})
  end

  def update(%{
    "jwt" => jwt,
    "old_username" => old_username,
    "new_username" => new_username,
    "secret_question_1" => secret_question_1,
    "secret_question_2" => secret_question_2,
    "secret_question_3" => secret_question_3,
    "secret_answer_1" => secret_answer_1,
    "secret_answer_2" => secret_answer_2,
    "secret_answer_3" => secret_answer_3
  } = params) do
    
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
