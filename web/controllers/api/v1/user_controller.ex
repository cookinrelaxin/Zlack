defmodule Zlack.UserController do
  use Zlack.Web, :controller

  @moduledoc """
    This module defines the callbacks for the part of the Zlack HTTP API that deals with users. These functions should mostly be wrappers for functions in Zlack.UserActions, in order to avoid code duplication. Authentication should be performed here, not in Zlack.RoomActions.
  """

  alias Zlack.{UserActions}

  #plug Guardian.Plug.EnsureAuthenticated, handler: Zlack.SessionController

  ###
  ### users
  ###

  @doc """
  Handle HTTP GET request for /api/v1/users?page=page
  """
  def index(conn, %{"page" => page}) do
    UserActions.index(%{"page" => page})
  end

  @doc """
  Handle HTTP POST request for /api/v1/users/?guest=true
  """
  def create(conn, %{"guest" => "true"} = params) do
    #IO.puts "
    #username = UserActions.create(:guest)
    {:ok, user} = UserActions.create(:guest)
    render conn, "guest.json", username: user.username
  end

  @doc """
  Handle HTTP POST request for /api/v1/users
  """
  def create(conn, %{}) do
    render conn, "test.json"
  end

  @doc """
  Handle HTTP GET request for /api/v1/users/:id
  """
  def show(conn, %{"id" => id}) do
    UserActions.show
  end

  @doc """
  Handle HTTP PATCH or PUT request for /api/v1/users/:id
  """
  def update(conn, %{"id" => id}) do
    UserActions.update
  end

  @doc """
  Handle HTTP DELETE request for /api/v1/users/:id
  """
  def delete(conn, %{"id" => id}) do
    UserActions.delete
  end

end
