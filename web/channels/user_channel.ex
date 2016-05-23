defmodule Zlack.UserChannel do
  use Zlack.Web, :channel

  @doc """
  This channel serves general purpose user functions and acts as a gatekeeper for the rest of the application. All authentication occurs in join/3.
  """

  alias Zlack.{User, Repo, MessageQueue, GuardianSerializer, Session, RoomActions}
  import Ecto.Query, only: [from: 2]

  def join("users:" <> _user_id = _channel_name, %{"jwt" => token}, socket) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        case GuardianSerializer.from_token(claims["sub"]) do
          {:ok, user} ->
            {:ok, assign(socket, :current_user, user)}
          {:error, _reason} ->
            join_error
        end
      {:error, _reason} ->
        join_error
    end
  end

  def join("users:" <> _user_id = _channel_name, %{"username" => username, "password" => password} = session_params, socket) do
    case Zlack.Session.authenticate(session_params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = user |> Guardian.encode_and_sign(:token)
        {:ok, assign(socket, :current_user, user)}
      :error ->
        {:error, %{"reason": "invalid username and password combination"}}
    end
  end

  defp join_error do
    {:error, %{"reason": "invalid jwt"}}
  end

  def handle_in("create_room" = event, %{
    "room_title" => "",
    "room_subtitle" => room_subtitle,
    "is_publicly_searchable" => is_publicly_searchable,
    "permissions" => permissions
  } = params, socket) do
    push socket, event, %{status: "error: room_title must not be empty"}
    {:noreply, socket}
  end

  def handle_in("create_room" = event, %{
    "room_title" => room_title,
    "room_subtitle" => "",
    "is_publicly_searchable" => is_publicly_searchable,
    "permissions" => permissions
  } = params, socket) do
    push socket, event, %{status: "error: room_subtitle must not be empty"}
    {:noreply, socket}
  end

  def handle_in("create_room" = event, %{
    "room_title" => room_title,
    "room_subtitle" => room_subtitle,
    "is_publicly_searchable" => is_publicly_searchable,
    "permissions" => permissions
  } = params, socket) do
    case (is_publicly_searchable in [true, false]) do
      true ->
        case (permissions in [
          "may_request_read_write_subscription",
          "may_request_read_subscription",
          "auto_grant_read_write_subscription",
          "auto_grant_read_subscription",
          "must_be_invited"]) do
          true ->
            case RoomActions.create(%{
              :owner => socket.assigns.current_user.id,
              :title => room_title,
              :subtitle => room_subtitle,
              :is_publicly_searchable => is_publicly_searchable,
              :permission_class => permissions}) do
              {:ok, room} ->
                push socket, event, %{status: :ok, response: %{room_id: room.id}}
                {:noreply, socket}
              _ ->
                push socket, event, %{status: "error: wtf!"}
            end
          false ->
            push socket, event, %{status: "error: invalid permissions"}
            {:noreply, socket}
          end
      false ->
        push socket, event, %{status: "error: invalid is_publicly_searchable"}
        {:noreply, socket}
    end
  end

  def handle_info(:after_join, socket) do
    channel_name = socket.assigns.channel_name
    pending_messages = MessageQueue.register_active_channel(channel_name)
    Enum.each(pending_messages, fn (m) -> 
      broadcast!(socket, m.event, m.message)
    end)
    {:noreply, socket}
  end

end
