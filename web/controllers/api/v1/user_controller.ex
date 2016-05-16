defmodule Zlack.UserController do
  use Zlack.Web, :controller

  @doc """
    This module defines the callbacks for the part of the Zlack HTTP API that deals with users. These functions should mostly be wrappers for functions in Zlack.UserActions, in order to avoid code duplication.
  """

  alias Zlack.{UserActions}

  plug Guardian.Plug.EnsureAuthenticated, handler: Zlack.SessionController

  ###
  ### users
  ###

  #GET /api/v1/users
  def index(conn, _params) do
    nil
  end

  #POST /api/v1/users
  def create(conn, _params) do
    nil
  end

  #GET /api/v1/users/:id
  def show(conn, %{"id" => id}) do
    nil
  end

  #PATCH /api/v1/users/:id and PUT /api/v1/users:id
  def update(conn, %{"id" => id}) do
    nil
  end

  #DELETE /api/v1/users/:id
  def delete(conn, %{"id" => id}) do
    nil
  end

end

