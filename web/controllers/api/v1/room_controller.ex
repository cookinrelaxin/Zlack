defmodule Zlack.RoomController do
  use Zlack.Web, :controller

  @moduledoc """
    This module defines the callbacks for the part of the Zlack HTTP API that deals with rooms. These functions should mostly be wrappers for functions in Zlack.RoomActions, in order to avoid code duplication between HTTP and WS callbacks. Authentication should be performed here, not in Zlack.RoomActions.
  """

  alias Zlack.{RoomActions}

  plug Guardian.Plug.EnsureAuthenticated, handler: Zlack.SessionController

  # @doc """
  # request: GET /rooms
  # Show all rooms
  # """
  # def index(conn, _params) do
  #   nil
  # end

  # @doc """
  # request: GET /rooms
  # Show all rooms
  # """
  # def index(conn, _params) do
  #   nil
  # end

  # def create(conn, %{"room" => room_params}) do
  #   current_user = Guardian.Plug.current_resource(conn)
  #   changeset = current_user
  #     |> build_assoc(:owned_rooms)
  #     |> Room.changeset(room_params)

  #   case Repo.insert(changeset) do
  #     {:ok, room} ->
  #       conn
  #         |> put_status(:created)
  #         |> render("show.json", room: room)
  #     {:error, changeset} ->
  #       conn
  #         |> put_status(:unprocessable_entity)
  #         |> render("error.json", changeset: changeset)

  #   end
  # end

  # def update(conn, _params) do
  #   :ok
  # end

  # def delete(conn, %{"room" => room_params}) do
  #   current_user = Guardian.Plug.current_resource(conn)
  #   Repo.delete(Repo.get_by(Room, name: room_params["name"], user_id: current_user.id))
  #   conn
  #   |> put_status(:ok)
  #   |> render("delete.json")
  # end

  ###
  ### rooms
  ###

  @doc """
  GET /api/v1/rooms
  """
  def index(conn, _params) do
    nil
  end

  @doc """
  POST /api/v1/rooms
  """
  def create(conn, _params) do
    nil
  end

  @doc """
  GET /api/v1/rooms/:id
  """
  def show(conn, %{"id" => id}) do
    nil
  end

  @doc """
  PATCH or PUT /api/v1/rooms/:id
  """
  def update(conn, %{"id" => id}) do
    nil
  end

  @doc """
  DELETE /api/v1/rooms/:id
  """
  def delete(conn, %{"id" => id}) do
    nil
  end

  ###
  ### rooms for a given user
  ###

  @doc """
  #GET /api/v1/users/:user_id/rooms
  """
  def index(conn, %{"user_id" => user_id}) do
    nil
  end

  @doc """
  POST /api/v1/users/:user_id/rooms
  """
  def create(conn, %{"user_id" => user_id}) do
    nil
  end


  @doc """
  GET /api/v1/users/:user_id/rooms/:id
  """
  def show(conn, %{"user_id" => user_id, "id" => id}) do
    nil
  end

  @doc """
  PATCH or PUT /api/v1/users/:user_id/rooms/:id
  """
  def update(conn, %{"user_id" => user_id, "id" => id}) do
    nil
  end

  @doc """
  DELETE /api/v1/users/:user_id/rooms/:id
  """
  def delete(conn, %{"user_id" => user_id, "id" => id}) do
    nil
  end

end
