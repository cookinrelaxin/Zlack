defmodule Zlack.UserView do
  use Zlack.Web, :view

  def render("forbidden.json", _assigns) do
    %{"error" => "forbidden"}
  end

  def render("guest.json", %{username: username}) do
    %{"username" => username}
  end

  def render("test.json", _assigns) do
    %{"username" => "Idaho!"}
  end

end
