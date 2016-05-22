defmodule Zlack.TestChannel do
  use Zlack.Web, :channel

  def join("test", _params, socket) do
    {:ok, socket}
  end

end
