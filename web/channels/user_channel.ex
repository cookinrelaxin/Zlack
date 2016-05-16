defmodule Zlack.UserChannel do
  use Zlack.Web, :channel

  alias Zlack.{MessageQueue}

  def join("users:" <> user_id = channel_name, _params, socket) do
    user = socket.assigns.current_user
    if String.to_integer(user_id) == user.id do
         send(self, :after_join)
        {:ok, assign(socket, :channel_name, channel_name)}
    else 
        {:error, %{reason: "Invalid user id"}}
    end
  end

  intercept ["invitation"]

  def handle_out("invitation", msg, socket) do
    push socket, "invitation", msg
    {:noreply, socket}
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
