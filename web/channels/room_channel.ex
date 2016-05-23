defmodule Zlack.RoomChannel do
  use Phoenix.Channel

  alias Zlack.{Repo, Room, User, MessageQueue, GuardianSerializer}

  def join("rooms:" <> room_id = channel_name, %{"jwt" => token}, socket) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        case GuardianSerializer.from_token(claims["sub"]) do
          {:ok, user} ->
            case is_subscribed(%{user: user, room_id: String.to_integer(room_id)}) do
              true ->
                {:ok, assign(socket, :current_user, user)}
              false ->
                {:error, %{"reason" => "must be subscribed to room in order to join"}}
            end
          {:error, _reason} ->
            join_error
        end
      {:error, _reason} ->
        join_error
    end
  end

  defp is_subscribed(%{user: user, room_id: room_id}) do
    owned_rooms = Repo.all(Ecto.assoc(user, :rooms))
    owned_room_ids = Enum.map(owned_rooms, fn(o) -> o.id end)
    IO.inspect owned_rooms
    IO.inspect owned_room_ids
    IO.inspect room_id
    case room_id in owned_room_ids do
      true ->
        IO.puts "it is true!!!"
        true
      false ->
        subscriptions = Repo.all(Ecto.assoc(user, :subscriptions))
        room_id in Enum.map(subscriptions, fn(o) -> o.room end)
    end
  end

  defp join_error do
    {:error, %{"reason": "invalid jwt"}}
  end

  # def join("rooms:" <> room_id = channel_name, %{"user_id" => user_id}, socket) do
  #   case socket.assigns.current_user.id do
  #     user_id ->
  #       user = socket.assigns.current_user
  #       owned_rooms = Repo.all(Ecto.assoc(user, :owned_rooms))
  #       owned_room = Enum.find(owned_rooms, fn(x) -> x.user_id end)
  #       if (owned_room != nil) do
  #         send(self, :after_join)
  #         Zlack.MessageQueue.register_active_channel(channel_name)
  #         {:ok, %{owner: true}, socket}
  #       else
  #         user_rooms = Repo.all(Ecto.assoc(user, :rooms))
  #         user_room = Enum.find(user_rooms, fn(x) -> x.user_id end)
  #         if (user_room != nil) do
  #           send(self, :after_join)
  #           Zlack.MessageQueue.register_active_channel(channel_name)
  #           {:ok, %{owner: false}, socket}
  #         else
  #           {:error, {"Unavailable"}}
  #         end
  #         
  #       end

  #     _ ->
  #       {:error, {"Unauthorized"}}
  #   end
  # end

  def handle_in("rooms:add_member",
    %{
      "room_id" => room_id,
      "user_email" => user_email},
    socket) do
    user = Repo.get_by!(User, email: user_email)
    room = Repo.get_by!(Room, id: room_id)
    changeset = user
      |> Ecto.build_assoc(:user_rooms)
      |> UserRoom.changeset(%{room_id: room.id})
    Repo.insert!(changeset)
    MessageQueue.dispatch_mail(%{
      :to_channel => "users:" <> Integer.to_string(user.id),
      :event => "invitation",
      :message => %{room_id: room_id, room_name: room.name}
    })

    {:noreply, socket}
  end

  def handle_in("rooms:send_message",
    %{
      "room_id" => room_id,
      "message" => msg},
    socket) do
    MessageQueue.dispatch_mail(%{
      :to_channel => "rooms:" <> Integer.to_string(room_id),
      :event => "user sent message",
      :message => %{:text => msg}
    })
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    broadcast!(socket, "user joined", %{"user" => socket.assigns.current_user})
    {:noreply, socket}
  end

  def terminate(msg, socket) do
    broadcast!(socket, "user left", %{"user" => socket.assigns.current_user})
    {:shutdown, :left}
  end

end
