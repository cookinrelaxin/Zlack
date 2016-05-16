defmodule Zlack.MessageController do
  use Zlack.Web, :controller

  @doc """
    This module defines the callbacks for the part of the Zlack HTTP API that deals with messages. These functions should mostly be wrappers for functions in Zlack.MessageActions, in order to avoid code duplication between HTTP and WS callbacks. Authentication should be performed here, not in Zlack.MessageActions.
  """

  alias Zlack.{MessageActions}

  plug Guardian.Plug.EnsureAuthenticated, handler: Zlack.SessionController

  ###
  ### messages
  ###

  #GET /api/v1/messages
  def index(conn, _params) do
    nil
  end

  #POST /api/v1/messages
  def create(conn, _params) do
    nil
  end

  #GET /api/v1/messages/:id
  def show(conn, %{"id" => id}) do
    nil
  end

  #PATCH /api/v1/messages/:id and PUT /api/v1/messages:id
  def update(conn, %{"id" => id}) do
    nil
  end

  #DELETE /api/v1/messages/:id
  def delete(conn, %{"id" => id}) do
    nil
  end

  ###
  ### messages for a given user
  ###

  #GET /api/v1/users/:user_id/messages
  def index(conn, %{"user_id" => user_id}) do
    nil
  end

  #POST /api/v1/users/:user_id/messages
  def create(conn, %{"user_id" => user_id}) do
    nil
  end

  #GET /api/v1/users/:user_id/messages/:id
  def show(conn, %{"user_id" => user_id, "id" => id}) do
    nil
  end

  #PATCH /api/v1/users/:user_id/messages/:id or PUT /api/v1/users/:user_id/messages/:id
  def update(conn, %{"user_id" => user_id, "id" => id}) do
    nil
  end

  #DELETE /api/v1/users/:user_id/messages/:id
  def delete(conn, %{"user_id" => user_id, "id" => id}) do
    nil
  end

  ###
  ### messages for a given room
  ###

  #GET /api/v1/rooms/:room_id/messages
  def index(conn, %{"room_id" => room_id}) do
    nil
  end

  #POST /api/v1/rooms/:room_id/messages
  def create(conn, %{"room_id" => room_id}) do
    nil
  end

  #GET /api/v1/rooms/:room_id/messages/:id
  def show(conn, %{"room_id" => room_id, "id" => id}) do
    nil
  end

  #PATCH /api/v1/rooms/:room_id/messages/:id or PUT /api/v1/rooms/:room_id/messages/:id
  def update(conn, %{"room_id" => room_id, "id" => id}) do
    nil
  end

  #DELETE /api/v1/rooms/:room_id/messages/:id
  def delete(conn, %{"room_id" => room_id, "id" => id}) do
    nil
  end

  ###
  ### messages for a given room belonging to a given user
  ###

  #GET /api/v1/users/:user_id/rooms/:room_id/messages
  def index(conn, %{"user_id" => user_id, "room_id" => room_id}) do
    nil
  end

  #POST /api/v1/users/:user_id/rooms/:room_id/messages
  def create(conn, %{"user_id" => user_id, "room_id" => room_id}) do
    nil
  end

  #GET /api/v1/users/:user_id/rooms/:room_id/messages/:id
  def show(conn, %{"user_id" => user_id, "room_id" => room_id, "id" => id}) do
    nil
  end

  #PATCH or PUT /api/v1/users/:user_id/rooms/:room_id/messages/:id
  def update(conn, %{"user_id" => user_id, "room_id" => room_id, "id" => id}) do
    nil
  end

  #DELETE /api/v1/users/:user_id/rooms/:room_id/messages/:id
  def delete(conn, %{"user_id" => user_id, "room_id" => room_id, "id" => id}) do
    nil
  end

end

