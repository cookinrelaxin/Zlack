defmodule Zlack.RoomClient do
  @moduledoc """
  """

  @url "localhost:4000/api/v1/rooms"
  @headers [{"accept", "application/json"},
      {"content-type", "application/json"}]

  def create_room(%{
    room: %{
      name: _name,
      purpose: _purpose
    },
  } = room_params, jwt) do
    HTTPoison.post!(@url, Poison.encode!(room_params), @headers ++ [{"authorization", jwt}])
  end

  def delete_room(%{
    room: %{
      name: _name,
      purpose: _purpose
    },
  } = room_params, jwt) do
    HTTPoison.request!(:delete, @url, Poison.encode!(room_params), @headers ++ [{"authorization", jwt}])
  end

end
