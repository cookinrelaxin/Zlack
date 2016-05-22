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

  # def connect(%{"token" => token}, socket) do
  #   case Guardian.decode_and_verify(token) do
  #     {:ok, claims} ->
  #       case GuardianSerializer.from_token(claims["sub"]) do
  #         {:ok, user} ->
  #           {:ok, assign(socket, :current_user, user)}
  #         {:error, _reason} ->
  #           :error
  #       end
  #     {:error, _reason} ->
  #       :error
  #   end
  # end

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(socket), do: "users_socket"
end
