defmodule Zlack.Cron do
  use GenServer

  alias Zlack.{Repo}
  require Ecto.Query

  ##Client API

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(%{}) do
    send self, :delete_old_guests
    {:ok, %{}}
  end

  ##Server callbacks

  def handle_info(:delete_old_guests, state) do
    #remove old guest users from db

    three_days_ago =
      Ecto.DateTime.utc
      |> Ecto.DateTime.to_erl
      |> :calendar.datetime_to_gregorian_seconds
      |> Kernel.-(60 * 60 * 24 * 3)
      |> :calendar.gregorian_seconds_to_datetime
      |> Ecto.DateTime.from_erl

    guests = Ecto.Query.from(u in Zlack.User, where: u.is_guest) |> Repo.all
    Enum.each(guests, fn(guest) ->
      if Ecto.DateTime.compare(guest.inserted_at, three_days_ago) == :lt do
        Repo.delete(guest)
      end
    end)
    
    hour = 60 * 60 * 1000
    day = 24 * hour
    Process.send_after(self, :delete_old_guests, day)
    {:noreply, state}
  end

end
