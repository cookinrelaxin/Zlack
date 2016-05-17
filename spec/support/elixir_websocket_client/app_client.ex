defmodule Zlack.AppClient do

  @moduledoc """
  AppClient module specifies the Zlack websocket API.
  """

  @url "ws://localhost:4000/socket/websocket"

  alias Zlack.{WebsocketClient}

  @doc """
  Takes a user's JSON web token and connects to the websocket endpoint.

  Returns {:ok, socket} if successful, {:error, {status_code, reason}} otherwise.
  """
  def connect_to_socket(jwt) do
    result = {:ok, _socket}
           = WebsocketClient.start_link(self, @url <> "?token=" <> jwt)
    result
  end

  @doc """
  Takes the socket returned from connect_to_socket/1, a valid room ID, and a valid user ID and joins the given room as the specified user.

  The calling process will receive the message:

    %{
      "event" => "phx_reply",
      "topic" => topic,
      "payload" => %{
        "status" => "ok",
        "response" => %{"owner" => _owner}
      }
    } = msg -> msg
       
  if successful, where topic is rooms:room_id, and _owner is a boolean specifying whether the user is the rooms owner.

  For each connected socket, the process will receive the message:

    %{
      "event" => "user joined",
      "topic" => topic,
      "payload" => %{
        "user" => %{
          "email" => email,
          "first_name" => first_name,
          "last_name" => last_name,
          "id" => id,
        }
      }
    }
      
      ....
  """
  def join_room(%{
    "socket" => socket,
    "room_id" => room_id,
    "user_id" => user_id
  } = _params) do
    topic = "rooms:" <> Integer.to_string(room_id)
    WebsocketClient.join(socket, topic, %{"user_id" => user_id})
  end

  @doc """
    Takes the socket returned from connect_to_socket/1, a valid user ID and joins the user's private channel.

    Returns

         %{
           "event" => "phx_reply",
           "topic" => topic,
           "payload" => %{
             "status" => "ok"
           }
         } = msg -> msg
         
    if successful, where topic is users:user_id. If unsuccessful, raises an exception.
  """
  def join_user_channel(%{
    "socket" => socket,
    "user_id" => user_id
  } = _params) do
    topic = "users:" <> Integer.to_string(user_id)
    WebsocketClient.join(socket, topic, %{})

    # receive do
    #   %{
    #     "event" => "phx_reply",
    #     "topic" => topic,
    #     "payload" => %{
    #       "status" => "ok"
    #     }
    #   } = msg -> msg
    # after
    #   @timeout -> raise "Timeout after " <> @timeout <> "ms trying to connect to user channel"
    # end
  end

  @doc """
  """
  def send_room_invitation(%{
    "socket" => socket,
    "topic" => topic,
    "room_id" => room_id,
    "user_email" => user_email
  } = _params) do
    event = "rooms:add_member"
    WebsocketClient.send_event(socket, topic, event, %{"room_id" => room_id, "user_email" => user_email})
  end

  # def send_message() do
  #   nil
  # end

end
