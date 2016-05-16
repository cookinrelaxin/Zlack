defmodule Zlack.UserController do
  use Zlack.Web, :controller

  @moduledoc """
    This module defines the callbacks for the part of the Zlack HTTP API that deals with users. These functions should mostly be wrappers for functions in Zlack.UserActions, in order to avoid code duplication. Authentication should be performed here, not in Zlack.RoomActions.
  """

  alias Zlack.{UserActions}

  plug Guardian.Plug.EnsureAuthenticated, handler: Zlack.SessionController

  ###
  ### users
  ###

  @doc """
  GET /api/v1/users?page=page
  """
  def index(conn, %{"page" => page) do
    UserActions.index(%{"page => page})
  end

  @doc """
  POST /api/v1/users
  """
  def create(conn, _params) do
    UserActions.create
  end

  @doc """
  GET /api/v1/users/:id
  """
  def show(conn, %{"id" => id}) do
    UserActions.show
  end

  @doc """
  PATCH /api/v1/users/:id or PUT /api/v1/users:id
  """
  def update(conn, %{"id" => id}) do
    UserActions.update
  end

  @doc """
  DELETE /api/v1/users/:id
  """
  def delete(conn, %{"id" => id}) do
    UserActions.delete
  end

end

