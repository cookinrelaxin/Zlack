defmodule Zlack.UserActions do

  @moduledoc """
    This module defines the real shit: the actions that mutate the state of the application, specifically regarding users. Authentication should not be performed here.
  """

  @doc """
    Take a given page number greater than or equal to zero and return at most 10 users per page from the DB.
  """
  def index(%{"page" => page}) do
    nil
  end

  @doc """
    Create a user with the given parameters and insert into the DB.
  """
  def create(%{
    "user" => %{
      "todo" => todo
    }
  } = user_params) do
    nil
  end

  @doc """
    Retrieve a user from the database with the given id.
  """
  def show(%{"id" => id}) do
    nil
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
