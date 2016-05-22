defmodule Zlack.UserChannel do
  use Zlack.Web, :channel

  alias Zlack.{MessageQueue}

  def join("users:" <> _user_id = _channel_name, %{"jwt" => _jwt}, socket) do
    {:ok, socket}
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
            push socket, event, %{status: :ok, response: %{room_id: 452}}
            {:noreply, socket}
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
