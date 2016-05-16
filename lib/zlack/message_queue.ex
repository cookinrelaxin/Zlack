defmodule Zlack.MessageQueue do
  use GenServer

  #Client API

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def dispatch_mail(%{
    :to_channel => to_channel,
    :event => event, 
    :message => message} = mail) do
    GenServer.cast(__MODULE__, mail)
  end

  def register_active_channel(channel_name) do
    GenServer.call(__MODULE__, %{:channel_to_register => channel_name})
  end

  def deregister_active_channel(channel_name) do
    GenServer.cast(__MODULE__, %{:channel_to_deregister => channel_name})
  end

  def reset do
    GenServer.cast(__MODULE__, :reset)
  end

  def get do
    GenServer.call(__MODULE__, :get)
  end

  #Server callbacks

  def init(:ok) do
    {:ok,
      %{
        :active_channels => [],
        :mailbox => []
      }
    }
  end

  def handle_cast(%{
    :to_channel => to_channel,
    :event => event, 
    :message => message} = mail, state) do

    if to_channel in state.active_channels do
      broadcast_mail(mail)
      {:noreply, state}
    else
      {:noreply,
        %{
          :active_channels => state.active_channels,
          :mailbox => state.mailbox ++ [mail]
         }
      }
    end
  end

  def handle_call(%{:channel_to_register => channel_name}, __from, state) do
    if channel_name in state.active_channels do
      {:reply, :ok, state}
    else
      pending_messages = Enum.filter_map(
        state.mailbox,
        fn(m) -> m.to_channel == channel_name end,
        fn(m) -> %{:event => m.event, :message => m.message} end
      )
      {:reply,
        pending_messages,
        %{
          :active_channels => state.active_channels ++ [channel_name],
          :mailbox => state.mailbox -- pending_messages
         }
      }
    end
  end

  def handle_call(:get, __from, state) do
    {:reply, state, state}
  end

  def handle_cast(%{:channel_to_deregister => channel_name}, state) do
    if channel_name in state.active_channels do
      {:noreply,
        %{
          :active_channels => state.active_channels -- [channel_name],
          :mailbox => state.mailbox
         }
      }
    else
      {:noreply, state}
    end
  end

  def handle_cast(:reset, state) do
    {:noreply, 
      %{
        :active_channels => [],
        :mailbox => []
      }
    }
  end

  defp broadcast_mail(%{
    :to_channel => to_channel,
    :event => event, 
    :message => message} = mail) do
    IO.puts "broadcast message"
    IO.inspect mail
    Zlack.Endpoint.broadcast_from!(self(),
      to_channel,
      event,
      message
    )
  end

end
