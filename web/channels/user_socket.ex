defmodule Zlack.UserSocket do
  use Phoenix.Socket

  alias Zlack.{GuardianSerializer}

  ## Channels
  channel "rooms:*", Zlack.RoomChannel
  channel "users:*", Zlack.UserChannel
  channel "test", Zlack.TestChannel
  channel "guest", Zlack.GuestChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  transport :longpoll, Phoenix.Transports.LongPoll

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(socket), do: "users_socket"
end
