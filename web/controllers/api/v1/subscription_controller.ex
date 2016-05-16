defmodule Zlack.SubscriptionController do
  use Zlack.Web, :controller

  @doc """
    This module defines the callbacks for the part of the Zlack HTTP API that deals with subscriptions. These functions should mostly be wrappers for functions in Zlack.SubscriptionActions, in order to avoid code duplication.
  """

  alias Zlack.{SubscriptionActions}

  plug Guardian.Plug.EnsureAuthenticated, handler: Zlack.SessionController

  ###
  ### subscriptions
  ###

  #GET /api/v1/subscriptions
  def index(conn, _params) do
    nil
  end

  #POST /api/v1/subscriptions
  def create(conn, _params) do
    nil
  end

  #GET /api/v1/subscriptions/:id
  def show(conn, %{"id" => id}) do
    nil
  end

  #PATCH /api/v1/subscriptions/:id and PUT /api/v1/subscriptions:id
  def update(conn, %{"id" => id}) do
    nil
  end

  #DELETE /api/v1/subscriptions/:id
  def delete(conn, %{"id" => id}) do
    nil
  end

  ###
  ### subscriptions for a given user
  ###

  #GET /api/v1/users/:user_id/subscriptions
  def index(conn, %{"user_id" => user_id}) do
    nil
  end

  #POST /api/v1/users/:user_id/subscriptions
  def create(conn, %{"user_id" => user_id}) do
    nil
  end

  #GET /api/v1/users/:user_id/subscriptions/:id
  def show(conn, %{"user_id" => user_id, "id" => id}) do
    nil
  end

  #PATCH /api/v1/users/:user_id/subscriptions/:id or PUT /api/v1/users/:user_id/subscriptions/:id
  def update(conn, %{"user_id" => user_id, "id" => id}) do
    nil
  end

  #DELETE /api/v1/users/:user_id/subscriptions/:id
  def delete(conn, %{"user_id" => user_id, "id" => id}) do
    nil
  end

  ###
  ### subscriptions for a given room
  ###

  #GET /api/v1/rooms/:room_id/subscriptions
  def index(conn, %{"room_id" => room_id}) do
    nil
  end

  #POST /api/v1/rooms/:room_id/subscriptions
  def create(conn, %{"room_id" => room_id}) do
    nil
  end

  #GET /api/v1/rooms/:room_id/subscriptions/:id
  def show(conn, %{"room_id" => room_id, "id" => id}) do
    nil
  end

  #PATCH /api/v1/rooms/:room_id/subscriptions/:id or PUT /api/v1/rooms/:room_id/subscriptions/:id
  def update(conn, %{"room_id" => room_id, "id" => id}) do
    nil
  end

  #DELETE /api/v1/rooms/:room_id/subscriptions/:id
  def delete(conn, %{"room_id" => room_id, "id" => id}) do
    nil
  end

  ###
  ### subscriptions for a given room belonging to a given user
  ###

  #GET /api/v1/users/:user_id/rooms/:room_id/subscriptions
  def index(conn, %{"user_id" => user_id, "room_id" => room_id}) do
    nil
  end

  #POST /api/v1/users/:user_id/rooms/:room_id/subscriptions
  def create(conn, %{"user_id" => user_id, "room_id" => room_id}) do
    nil
  end

  #GET /api/v1/users/:user_id/rooms/:room_id/subscriptions/:id
  def show(conn, %{"user_id" => user_id, "room_id" => room_id, "id" => id}) do
    nil
  end

  #PATCH or PUT /api/v1/users/:user_id/rooms/:room_id/subscriptions/:id
  def update(conn, %{"user_id" => user_id, "room_id" => room_id, "id" => id}) do
    nil
  end

  #DELETE /api/v1/users/:user_id/rooms/:room_id/subscriptions/:id
  def delete(conn, %{"user_id" => user_id, "room_id" => room_id, "id" => id}) do
    nil
  end

end
